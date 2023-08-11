#!/bin/sh
sed -i '/Disable polkit/,+8 d' meson.build

sed '/request_name/i\
r = sd_bus_set_exit_on_disconnect(m->bus, true);\
if (r < 0)\
    return log_error_errno(r, "Failed to set exit on disconnect: %m");' \
    -i src/login/logind.c
