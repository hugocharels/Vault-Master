use crate::TimeStep;

use super::Task;

#[derive(Debug, Clone, PartialEq)]
pub struct Job {
    task: Task,
    deadline: TimeStep,
    remaining_time: TimeStep,
    id: u32,
}

impl Job {
    pub fn new(task: Task, deadline: TimeStep, id: u32) -> Self {
        Self {
            remaining_time: task.wcet(),
            task,
            deadline,
            id,
        }
    }

    pub fn deadline_missed(&self, t: TimeStep) -> bool {
        self.remaining_time > 0 && t > self.deadline
    }

    pub fn is_complete(&self) -> bool {
        self.remaining_time == 0
    }

    pub fn schedule(&mut self, n_steps: TimeStep) {
        self.remaining_time -= n_steps;
    }

    pub fn task(&self) -> &Task {
        &self.task
    }

    pub fn remaining_time(&self) -> u32 {
        self.remaining_time
    }
}

#[cfg(test)]
mod test {
    use crate::models::Task;

    #[test]
    fn schedule() {
        let mut task = Task::new(0, 0, 10, 30, 30);
        let mut j = task.spawn_job(0).unwrap();
        assert!(j.remaining_time() == 10);
        j.schedule(1);
        assert!(j.remaining_time() == 9);
    }

    #[test]
    fn is_complete() {
        let mut task = Task::new(0, 0, 10, 30, 30);
        let mut j = task.spawn_job(0).unwrap();
        assert!(!j.is_complete());
        j.schedule(10);
        assert!(j.is_complete());
    }

    #[test]
    fn deadline_missed() {
        let mut task = Task::new(0, 0, 10, 30, 30);
        let j = task.spawn_job(0).unwrap();
        assert!(!j.deadline_missed(5));
        assert!(j.deadline_missed(31));
    }
}
