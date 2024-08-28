/// Represents the different flags that can be applied to tasks in the [Tasks] section.
enum TaskFlag {
  /// Specifies that the task can be checked even when none of its children are checked.
  checkableAlone,

  /// Instructs Setup that this task should be unchecked initially when Setup
  /// finds a previous version of the same application is already installed.
  ///
  /// This flag is effectively disabled if the `UsePreviousTasks` directive is set to `no`.
  checkedOnce,

  /// Prevents the task from automatically becoming checked when its parent is checked.
  /// 
  /// Has no effect on top-level tasks, and cannot be combined with the `exclusive` flag.
  dontInheritCheck,

  /// Makes the task mutually exclusive with sibling tasks that also have the `exclusive` flag.
  exclusive,

  /// Instructs Setup to ask the user to restart the system at the end of installation
  /// if this task is selected, regardless of whether it is necessary.
  restart,

  /// Instructs Setup that this task should be unchecked initially.
  unchecked;

  @override
  String toString(){
    return name.toLowerCase();
  }
}