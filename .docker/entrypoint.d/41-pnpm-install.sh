#!/bin/sh
script_name="pnpm-install"

pnpm install --force --frozen-lockfile
pnpm build
