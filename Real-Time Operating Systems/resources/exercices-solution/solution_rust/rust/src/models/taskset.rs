use super::{Job, Task};

pub struct TaskSet {
    tasks: Vec<Task>,
}

impl TaskSet {
    pub fn new(tasks: Vec<Task>) -> Self {
        Self { tasks }
    }

    pub fn release_jobs(&mut self, current_time: u32) -> Vec<Job> {
        self.tasks
            .iter_mut()
            .filter_map(|t| t.spawn_job(current_time))
            .collect()
    }
}

#[cfg(test)]
mod tests {
    use crate::models::Task;

    use super::TaskSet;

    #[test]
    fn test_taskset() {
        let tasks = vec![Task::new(0, 0, 10, 20, 50), Task::new(1, 0, 20, 40, 40)];
        let mut ts = TaskSet::new(tasks);
        assert!(ts.release_jobs(0).len() == 2);
        assert!(ts.release_jobs(3).is_empty());
    }
}
