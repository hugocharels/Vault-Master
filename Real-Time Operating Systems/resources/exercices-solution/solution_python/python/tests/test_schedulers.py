from scheduling import rate_monotonic, Task


def test_rm():
    t1 = Task(0, offset=0, wcet=10, deadline=10, period=10)
    t2 = Task(1, offset=0, wcet=20, deadline=20, period=20)

    j1 = t1.spawn_job(0)
    j2 = t2.spawn_job(0)

    assert rate_monotonic([j1, j2]) == j1
    assert rate_monotonic([j2, j1]) == j1
    assert rate_monotonic([]) is None
