#!/usr/bin/env bash
sh scripts/testing/download.sh
sh scripts/testing/lsp.sh src
selene src

