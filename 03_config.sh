#!/bin/bash
oc env dc/my12factorapp GREETING="Hi {name}! - My Configuration has changed"
echo "Configuration updated. Please check again http://12factorappdemo.10.1.2.2.nip.io/api/hello/Rafael"
