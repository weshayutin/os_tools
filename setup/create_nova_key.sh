#!/bin/bash

ssh-keygen -t rsa -f customkey
chmod 600 customkey*
nova keypair-add customkey --pub-key customkey.pub
nova keypair-list

