#!/usr/bin/env bash
opkg install *.ipk --force-reinstall
service rpcd restart