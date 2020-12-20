#!/bin/bash

docker run --rm -v $(pwd)/artifacts:/opt/documents/ detectionscanner
