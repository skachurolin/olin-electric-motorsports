"""
A small script to generate an exhaustive list of
all the commands you can run on the HitL system.

At a high level, a test includes 3 main components:
* "set" statements that provide inputs to the harness
* "get" statements that retrive outputs from the harness
* "assert" statements that check that the output is what we expect

At a low level, writing these "get" and "set" statements can be daunting.

For example, let's say I know I want to simulate the throttle pedal being
pressed halfway. How can I do that?

This script generates a single file that people can CMD-F their way
through to find the command they are looking for. In theory, all the
information in the generated file is redundant with the contents of our
.dbc CAN spec and .csv HitL IO spec, but this should be a good place for
beginers to look for commands.
"""
# Imports
import os
from hitl.utils import artifacts_path

# Constants
HEADER = "# HitL Command List\n\n ### Welcome to the the HitL command list! You can CMD-F your way through this file to find the singal you're looking for!\n\n\n\n"
FOOTER = "\n\n\n ## If you have any questions, or it looks like a signal is missing, contact Alex Wenstrup.\n\n Generated by hardware_in_the_loop/software/docs/make_cmd_list.py"

PIN_IO_PATH = os.path.join(artifacts_path, "pin_info.csv")
DBC_PATH = "todo/no/path/yet"
OUTPUT_PATH = os.path.join(artifacts_path, "cmd_list.md")


# Helper functions
def generate_header() -> str:
    return HEADER


def generate_footer() -> str:
    return FOOTER


def generate_io_command(signal: str, kind: str) -> str:
    out = ""

    if (kind == "SET") or (kind == "BOTH"):
        out += f"To set {signal} to `value`, you can run `harness.io.set_state({signal}, value)`\n\n"

    if (kind == "GET") or (kind == "BOTH"):
        out += f"To get {signal}, you can run `harness.io.get_state({signal})`\n\n"

    return out


def generate_can_command(signal: str) -> str:
    return f"To get {signal}, you can run `harness.can.set_state({signal})`\n\n"


def generate_all_io_commands(filepath: str) -> str:
    out = ""

    with open(filepath, "r") as f:
        line = f.readline()  # clear the header line
        line = f.readline()  # get the first data line ready
        while line != "":  # keep reading until we hit the end
            # parse line
            data = line.split(",")
            signal = data[4].strip()
            kind = data[6].strip()
            out += generate_io_command(signal, kind)

            line = f.readline()

    return out


def generate_all_can_commands(filepath: str) -> str:
    # TODO
    return ""


def write_to_file(filepath: str, data: str) -> None:
    """Write a string to a file"""
    with open(filepath, "w") as f:
        f.write(data)


# Main function
if __name__ == "__main__":
    output = ""

    output += generate_header()
    output += generate_all_io_commands(PIN_IO_PATH)
    # TODO output += generate_header()
    output += generate_footer()

    write_to_file(OUTPUT_PATH, output)
