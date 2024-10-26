from typing import Optional, Callable
from .models import Job


Scheduler = Callable[[list[Job]], Optional[Job]]


def rate_monotonic(jobs: list[Job]) -> Optional[Job]:
    if len(jobs) == 0:
        return None
    elected_job = jobs[0]
    for job in jobs[1:]:
        if job.task.period < elected_job.task.period:
            elected_job = job
    return elected_job
