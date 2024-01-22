 
import struct, random

def clamp(minvalue, value, maxvalue):
    return max(minvalue, min(value, maxvalue))

def opt(name, var_type, value=None, description="", sane_low=None, sane_high=None):
    opts = { name: {"type":var_type}}
    if not value is None :
        opts[name]["default"] = value
    if description:
        opts[name]["description"] = description
    if not sane_low is None:
        opts[name]["sane_low"] = sane_low
    if not sane_high is None:
        opts[name]["sane_high"] = sane_high
    return opts

def random_position(w, h):
    return (random.randrange(0, w), random.randrange(0, h))

def sum_tuples(*argv):
    total = []
    for tup in argv:
        if not total:
            total = list(tup)
            continue
        for i in range(len(tup)):
            total[i] += tup[i]

    return tuple(total)