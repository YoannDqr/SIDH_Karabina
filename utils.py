def is_int(value):
    assert isinstance(value, int)
    return value

def mod_inverse(a, n):
    """Return the inverse of a mod n.

    n must be prime.

    >>> mod_inverse(42, 2017)
    1969

    """
    b = n
    if abs(b) == 0:
        return (1, 0, a)

    x1, x2, y1, y2 = 0, 1, 1, 0
    while abs(b) > 0:
        q, r = divmod(a, b)
        x = x2 - q * x1
        y = y2 - q * y1
        a, b, x2, x1, y2, y1 = b, r, x1, x, y1, y

    return x2 % n