use crate::models::Job;

pub type Scheduler = fn(&mut Vec<Job>) -> Option<&mut Job>;

pub fn rate_monotonic(jobs: &mut Vec<Job>) -> Option<&mut Job> {
    if jobs.is_empty() {
        return None;
    }
    jobs.iter_mut().reduce(|res, job| {
        if job.task().period() < res.task().period() {
            job
        } else {
            res
        }
    })
}

#[cfg(test)]
mod tests {
    use crate::models::Task;

    use super::{rate_monotonic, Scheduler};
    #[test]
    fn type_check() {
        let _rm: Scheduler = rate_monotonic;
    }

    #[test]
    fn rm() {
        let mut t1 = Task::new(0, 0, 10, 20, 40);
        let mut t2 = Task::new(1, 0, 10, 20, 50);
        let mut jobs = vec![t1.spawn_job(0).unwrap(), t2.spawn_job(0).unwrap()];
        let elected = rate_monotonic(&mut jobs);
        assert!(elected.is_some());
        assert!(elected.unwrap().task().id() == 0);
    }
}
