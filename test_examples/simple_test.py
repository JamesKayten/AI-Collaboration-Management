#!/usr/bin/env python3
"""Simple test module - corrected version."""

import os
import sys
import json


def good_function(x, y):
    """Add two numbers together."""
    return x + y


class GoodClass:
    """A properly formatted class."""

    def __init__(self):
        """Initialize with empty data."""
        self.data = {}

    def get_data(self):
        """Return data or None if empty."""
        if self.data == {}:
            return None
        else:
            return self.data
