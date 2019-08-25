#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

# To Get List for Rebuilding or TLD
docker ps --format '{{.Names}}' > /pg/tmp/backup.list
sed -i -e "/traefik/d" /pg/tmp/backup.list
sed -i -e "/watchtower/d" /pg/tmp/backup.list
sed -i -e "/wp-*/d" /pg/tmp/backup.list
sed -i -e "/x2go*/d" /pg/tmp/backup.list
sed -i -e "/plexguide/d" /pg/tmp/backup.list
sed -i -e "/cloudplow/d" /pg/tmp/backup.list
sed -i -e "/oauth/d" /pg/tmp/backup.list
sed -i -e "/pgui/d" /pg/tmp/backup.list

rm -rf /pg/tmp/backup.build 1>/dev/null 2>&1
#### Commenting Out To Let User See
while read p; do
  echo -n "$p" >> /pg/tmp/backup.build
  echo -n " " >> /pg/tmp/backup.build
done </pg/tmp/backup.list
running=$(cat /pg/tmp/backup.list)

# If Blank, Exit
if [ "$running" == "" ]; then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️ WARNING! - No Apps are Running! Exiting!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 2
exit
fi

# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Traefik - Provider Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NOTE: App Must Be Actively Running! To quit, type >>> exit

EOF
echo PROGRAMS:
echo $running
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Standby
read -p 'Type an Application Name | Press [ENTER]: ' typed < /dev/tty

if [ "$typed" == "exit" ]; then exit; fi

tcheck=$(echo $running | grep "\<$typed\>")
if [ "$tcheck" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️ WARNING! - Type an Application Name! Case Senstive! Restarting!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 3
bash /pg/traefik/tld.sh
exit
fi

if [ "$typed" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️ WARNING! - The TLD Application Name Cannot Be Blank!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 3
bash /pg/traefik/tld.sh
exit
else
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  PASS: TLD Application Set
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Prevents From Repeating
cat /pg/var/tld.program > /pg/var/old.program
echo "$typed" > /pg/var/tld.program

sleep 3
fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🍖  NOM NOM - Rebuilding Your Old App & New App Containers!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

sleep 4
old=$(cat /pg/var/old.program)
new=$(cat /pg/var/tld.program)

touch /pg/var/tld.type
tldtype=$(cat /pg/var/tld.type)

if [[ "$old" != "$new" && "$old" != "NOT-SET" ]]; then

  if [[ "$tldtype" == "standard" ]]; then
    if [ -e "bash /pg/apps/programs/$old/start.sh" ]; then bash /pg/apps/programs/$old/start.sh; fi
  elif [[ "$tldtype" == "wordpress" ]]; then
    echo "$old" > /pg/tmp/wp_id
    ansible-playbook /pg/pgpress/wordpress.yml
    echo "$typed" > /pg/tmp/wp_id
  fi

fi

if [ -e "bash /pg/apps/programs/$new/start.sh" ]; then bash /pg/apps/programs/$new/start.sh; fi
echo "standard" > /pg/var/tld.type
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
read -p '✅️ Process Complete! Acknowledge Info | Press [ENTER] ' name < /dev/tty
