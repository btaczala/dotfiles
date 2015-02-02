#!/bin/bash

task config taskd.server freecinc.com:53589
mkdir -p ~/.task
task config taskd.key ~/drive/freecinc/freecinc_7c82c18e.key.pem
task config taskd.certificate ~/drive/freecinc/freecinc_7c82c18e.cert.pem
task config taskd.ca ~/drive/freecinc/freecinc_7c82c18e.ca.pem
task config taskd.credentials -- \
    'FreeCinc/freecinc_7c82c18e/f034d3ce-dcab-4dd0-ad7d-eef417b83301'

task diagnostics


