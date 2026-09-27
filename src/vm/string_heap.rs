//! 論理的な所有数はRustの一時コピーと分離します。最後のreleaseで内容を回収します。
use super::{Value, VmErrorKind, VmResult};
use std::{cell::RefCell, collections::HashMap, rc::Rc};
#[derive(Debug, Clone)]
pub(crate) struct StringValue {
    bytes: Rc<RefCell<String>>,
    allocation: Option<u64>,
}
impl From<String> for StringValue {
    fn from(value: String) -> Self {
        Self {
            bytes: Rc::new(RefCell::new(value)),
            allocation: None,
        }
    }
}
impl PartialEq for StringValue {
    fn eq(&self, other: &Self) -> bool {
        *self.bytes.borrow() == *other.bytes.borrow()
    }
}
impl Eq for StringValue {}
impl StringValue {
    pub(super) fn len(&self) -> usize {
        self.bytes.borrow().len()
    }
    pub(crate) fn text(&self) -> String {
        self.bytes.borrow().clone()
    }
}
pub(super) struct StringHeap {
    limit: u64,
    live: u64,
    next: u64,
    #[cfg(test)]
    fail_next_allocation: bool,
    allocations: HashMap<u64, (Rc<RefCell<String>>, u64)>,
}
impl StringHeap {
    pub(super) fn new(limit: u64) -> Self {
        Self {
            limit,
            live: 0,
            next: 0,
            allocations: HashMap::new(),
            #[cfg(test)]
            fail_next_allocation: false,
        }
    }
    #[cfg(test)]
    pub(super) fn assert_empty(&self) {
        debug_assert_eq!(self.live, 0);
        debug_assert!(self.allocations.is_empty());
    }
    pub(super) fn concat(
        &mut self,
        left: &StringValue,
        right: &StringValue,
    ) -> VmResult<StringValue> {
        let left = left.bytes.borrow();
        let right = right.bytes.borrow();
        let size = allocation_size(left.len(), right.len())?;
        if size == 0 {
            return Ok(String::new().into());
        }
        let live = self
            .live
            .checked_add(size as u64)
            .filter(|n| *n <= self.limit)
            .ok_or(VmErrorKind::AllocationLimitExceeded)?;
        #[cfg(test)]
        if std::mem::take(&mut self.fail_next_allocation) {
            return Err(VmErrorKind::AllocationFailed);
        }
        let mut bytes = String::new();
        bytes
            .try_reserve_exact(size)
            .map_err(|_| VmErrorKind::AllocationFailed)?;
        self.allocations
            .try_reserve(1)
            .map_err(|_| VmErrorKind::AllocationFailed)?;
        bytes.push_str(&left);
        bytes.push_str(&right);
        let bytes = Rc::new(RefCell::new(bytes));
        let id = self.next;
        self.next += 1;
        self.allocations.insert(id, (bytes.clone(), 1));
        self.live = live;
        Ok(StringValue {
            bytes,
            allocation: Some(id),
        })
    }
    pub(super) fn manage(&mut self, value: &StringValue, retain: bool) -> VmResult<()> {
        let Some(id) = value.allocation else {
            return Ok(());
        };
        let (_, count) = self
            .allocations
            .get_mut(&id)
            .ok_or(VmErrorKind::InvalidStringOwnership)?;
        if retain {
            *count = count
                .checked_add(1)
                .ok_or(VmErrorKind::InvalidStringOwnership)?;
            return Ok(());
        }
        *count -= 1;
        if *count == 0 {
            let (bytes, _) = self.allocations.remove(&id).unwrap();
            self.live -= bytes.borrow().len() as u64;
            *bytes.borrow_mut() = String::new();
        }
        Ok(())
    }
}
impl Drop for StringHeap {
    fn drop(&mut self) {
        // 失敗した実行も、外部へ戻る前に内容を回収します。
        for (bytes, _) in self.allocations.values() {
            *bytes.borrow_mut() = String::new();
        }
    }
}
fn allocation_size(left: usize, right: usize) -> VmResult<usize> {
    left.checked_add(right)
        .filter(|n| *n <= isize::MAX as usize)
        .ok_or(VmErrorKind::AllocationSizeOverflow)
}
pub(super) fn pop(stack: &mut Vec<Value>) -> VmResult<StringValue> {
    match super::pop_value(stack)? {
        Value::String(v) => Ok(v),
        v => Err(VmErrorKind::TypeMismatch {
            expected: crate::bytecode::Type::String,
            actual: v.ty(),
        }),
    }
}
pub(super) fn freeze(value: Value) -> Value {
    match value {
        Value::String(v) => Value::String(v.text().into()),
        Value::Array { element, values } => Value::Array {
            element,
            values: values.into_iter().map(freeze).collect(),
        },
        Value::Aggregate { type_id, fields } => Value::Aggregate {
            type_id,
            fields: fields.into_iter().map(freeze).collect(),
        },
        v => v,
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn checked_sizes_do_not_wrap() {
        assert_eq!(
            allocation_size(usize::MAX, 1),
            Err(VmErrorKind::AllocationSizeOverflow)
        );
        assert_eq!(
            allocation_size(isize::MAX as usize, 1),
            Err(VmErrorKind::AllocationSizeOverflow)
        );
        assert_eq!(allocation_size(0, 0), Ok(0));
    }
    #[test]
    fn sharing_release_and_failed_allocation_keep_accounting() {
        let mut heap = StringHeap::new(4);
        let a = "a".to_owned().into();
        let b = "b".to_owned().into();
        let dynamic = heap.concat(&a, &b).unwrap();
        heap.manage(&dynamic, true).unwrap();
        assert_eq!(heap.live, 2);
        heap.manage(&dynamic, false).unwrap();
        assert_eq!(dynamic.text(), "ab");
        heap.fail_next_allocation = true;
        assert_eq!(
            heap.concat(&a, &b).unwrap_err(),
            VmErrorKind::AllocationFailed
        );
        assert_eq!(heap.live, 2);
        heap.manage(&dynamic, false).unwrap();
        heap.assert_empty();
        // スロットにRustの一時コピーが残っていても内容は回収済みです。
        assert_eq!(dynamic.text(), "");
    }
    #[test]
    fn failing_execution_boundary_reclaims_surviving_handles() {
        let dynamic = {
            let mut heap = StringHeap::new(2);
            let a = "a".to_owned().into();
            let dynamic = heap.concat(&a, &a).unwrap();
            assert_eq!(
                heap.concat(&a, &a).unwrap_err(),
                VmErrorKind::AllocationLimitExceeded
            );
            dynamic
        };
        assert_eq!(dynamic.text(), "");
    }
}

#[cfg(test)]
mod lifetime_tests {
    use super::*;
    #[test]
    fn compiled_scope_cleanup_releases_every_live_entry_allocation() {
        let sources = [
            include_str!("../../examples/string_concat.ceru"),
            include_str!("../../examples/array_copy_lifetimes.ceru"),
            r#"enum E{A{text:string},B} fn make()->E {v:E=E::A{text:concat("a","b")};return v;} mut e:E=make(); saved:E=e; e=E::B{}; print(saved);"#,
            r#"for (item:string in [concat("a","b"),concat("c","d")]) {print(item);break;}"#,
        ];
        for source in sources {
            let code = crate::compile_to_bytecode(source).unwrap();
            let mut heap = StringHeap::new(code.string_heap_limit);
            crate::vm::execute_frame(
                &code,
                crate::vm::Frame::Entry,
                vec![],
                &mut String::new(),
                &mut heap,
            )
            .unwrap();
            heap.assert_empty();
        }
    }
    #[test]
    fn duplicate_release_is_an_internal_error_not_a_language_failure() {
        let mut heap = StringHeap::new(2);
        let static_value = "a".to_owned().into();
        let value = heap.concat(&static_value, &static_value).unwrap();
        heap.manage(&value, false).unwrap();
        assert_eq!(
            heap.manage(&value, false),
            Err(VmErrorKind::InvalidStringOwnership)
        );
        assert_eq!(
            crate::runtime::FailureCode::from_vm(VmErrorKind::InvalidStringOwnership),
            None
        );
    }
}
