echo "WE'RE ABOUT TO STOP RIGHT NOW !"
echo "Stop the JBoss Server"
$APPSRV_HOME/bin/jboss-cli.sh -c --command=':shutdown'
JBOSS_STATE="running"
while [[ $JBOSS_STATE == "running" ]]; do
    JBOSS_STATE=$($APPSRV_HOME/bin/jboss-cli.sh 'connect,:read-attribute(name=server-state),q' | grep result);
    if [[ -z $JBOSS_STATE ]]; then
        JBOSS_STATE="stopped";
    else
        JBOSS_STATE=`echo "$JBOSS_STATE" | tr -s \" " " | cut -d ' ' -f 4`;
    fi
    echo "JBoss is $JBOSS_STATE";
    sleep 1;
done
# jboss is now stopped

echo "Everything is properly stopped, we can exit"
# everything is properly stopped, we can exit
rm -f /opt/letitrun
