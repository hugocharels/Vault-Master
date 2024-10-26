from .models import TaskSet, Job
from .schedulers import Scheduler
from .exceptions import DeadlineMissedException


def simulate(taskset: TaskSet, scheduler: Scheduler, t_max: int):
    queue: list[Job] = []
    for t in range(t_max + 1):
        # Release new jobs
        queue += taskset.release_jobs(t)
        # Check for deadlines
        for job in queue:
            if job.deadline_missed(t):
                raise DeadlineMissedException(f"Deadline missed for {job} at time {t} !")
        elected_job = scheduler(queue)
        if elected_job is not None:
            elected_job.schedule(1)
            if elected_job.is_complete():
                queue.remove(elected_job)
