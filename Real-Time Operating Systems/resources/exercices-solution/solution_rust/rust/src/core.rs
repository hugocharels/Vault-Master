use crate::{
    errors::SchedulingError,
    models::{TaskSet, TimeStep},
    scheduler::Scheduler,
};

pub fn simulation(
    mut taskset: TaskSet,
    scheduler: Scheduler,
    t_max: TimeStep,
) -> Result<(), SchedulingError> {
    let mut queue = vec![];
    for t in 0..t_max {
        // Release new jobs
        queue.extend(taskset.release_jobs(t));
        // Check for deadlines
        for job in &queue {
            if job.deadline_missed(t) {
                return Err(SchedulingError::DeadlineMiss {
                    job: job.clone(),
                    t,
                });
            }
        }
        if let Some(elected) = scheduler(&mut queue) {
            elected.schedule(1);
        }
        // Only keep the jobs that are not complete. This is ne very efficient
        // since we should only check for `elected`, but it is to avoid fighting
        // the borrow checker.
        queue.retain(|j| !j.is_complete());
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use crate::{scheduler::rate_monotonic, Task, TaskSet};

    use super::simulation;

    #[test]
    fn simulation_ok() {
        let t1 = Task::new(0, 0, 10, 20, 40);
        let t2 = Task::new(1, 0, 10, 20, 40);
        let ts = TaskSet::new(vec![t1, t2]);
        assert!(simulation(ts, rate_monotonic, 100).is_ok());
    }

    #[test]
    fn simulation_fails() {
        let t1 = Task::new(0, 0, 10, 20, 20);
        let t2 = Task::new(1, 0, 11, 20, 20);
        let ts = TaskSet::new(vec![t1, t2]);
        assert!(simulation(ts, rate_monotonic, 100).is_err());
    }
}
