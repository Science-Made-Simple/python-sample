#!bin/bash

dir=/opt/sms/Ai


if [ "$LIFECYCLE_EVENT" == "AfterInstall" ]
then
    echo "[Unit]
Description=SMS AI
Documentation=https://github.com/science-made-simple/webapp
After=network.target network-online.target
Requires=network-online.target

[Service]
Type=simple
User=ec2-user
Group=ec2-user
Environment="PYTHONPATH=${dir}/site-packages:$PYTHONPATH"
ExecStart=
ExecStart=/usr/bin/python3 ${dir}/main.py > /dev/null
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/sms.ai@.service
    systemctl daemon-reload
    systemctl enable --now sms.ai@api.service
fi

if [ "$LIFECYCLE_EVENT" == "ApplicationStop" ]
then
    systemctl stop --now sms.ai@api.service
fi

if [ "$LIFECYCLE_EVENT" == "ApplicationStart" ]
then
    systemctl restart sms.ai@api.service
fi

if [ "$LIFECYCLE_EVENT" == "ValidateService" ]
then
    systemctl is-active sms.ai@api.service
fi
