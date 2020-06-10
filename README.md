# IT infrastructure - prerequisites
## machine:
- docker daemon, working with performant overlay (NOT loopback). For overlay, make sure /var/lib/docker is xfs.
- machine should have at least 4 cores, with 4GB Ram available for it

## network
- confirm the server is reachable from the outside world/loadballancer (sw or hw).
- for HTTPS, you may want to do tls termination (keys/certs) in the loadbalancer (e.g. haproxy) or in an nginx in front.
- get ssl certs from letsencrypt in an automated manner (with automatic cert rotation).
- confirm the dns is working and pointing to your ip
- confirm the tls termination is working, and certificates are valid
- TEST it, by running a simple hello world docker container behind the loadballancer and confirm is fine
- deploy the openproject, using steps below

# SETUP EMAIL SERVER DETAILS:
Without this step, people will not get notification emails from the system.
You may want to create a dedicated email address for it (or reuse an exisitng one).
1. The email server setup is in docker.env, with an example in the ANNEX1 below. Adapt as required.
2. Also login as admin, and update: https://<new_url>/admin/mail_notifications
3. Test it works by triggering a notification

# SETUP url/hostname
1. Login as admin, and update: https://<new_url>/settings

# DOCKER:
## SETUP DOCKER:
1. set full paths to the restart.sh

# TROUBLESHOOTING:
1. When you have a system low in resources, you get error when eager_load is true due to 90 sec timeout when low resources=> modified production.rb and set it to false.

# BACKUP
1. There are two important folders that have to be backed up:
- pgdata (the postgres database data) -> ~100Mb only
- static (everything else) -> usually also very small, unless there will be huge attachments added in the future
2. make periodic (at least weekly) automated backups.
3. for guaranteed consistent data, turn off the container before backup, and turn it on after.
4. keep at least 2 months old backups.
5. Example script, run: ./stop_and_backup.sh

# RESTORE:
Make sure all parties agree to restore from an older backup, as they will loose all the changes in between.
Always backup before upgrades.
1. simply restore the two folders 

# UPGRADE:
Read release notes of new releases here: https://github.com/opf/openproject/releases
Find latest images on: https://hub.docker.com/r/openproject/community/tags
Ideally wait ~1-2 weeks from the time there is a new release, to make sure it's stable enough.
Read the issues section, to verify there are no major known issues.
1. Make backup
2. change the IMG parameter in the restart.sh
3. run: restart.sh


# ANNEX1 - docker.env
Example setup. Update as required.
Remember: there is one more email setup once you login: https://<new_url>/admin/mail_notifications
Here is the docker.env (note: it can hold other params as well, not only email related)
```
SECRET_KEY_BASE=.....

# EMAIL RELATED:
EMAIL_DELIVERY_METHOD=smtp
SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=587
SMTP_DOMAIN=smtp.gmail.com
SMTP_AUTHENTICATION=plain
SMTP_ENABLE_STARTTLS_AUTO=true
SMTP_USER_NAME='openenergyprojects@gmail.com'
SMTP_PASSWORD='<conctactus>'
#https://support.google.com/a/answer/176600?hl=en
#https://support.google.com/accounts/answer/6010255?hl=en
#https://support.google.com/mail/answer/185833

## INCOMING EMAILS:
# https://docs.openproject.org/installation-and-operations/configuration/incoming-emails/
IMAP_SSL=true #set to true or false depending on whether the ActionMailer IMAP connection requires implicit TLS/SSL
IMAP_PORT=993
IMAP_HOST=imap.gmail.com
IMAP_USERNAME='openenergyprojects'
IMAP_PASSWORD='.....'
#Optional ENV variables:
#IMAP_CHECK_INTERVAL=600 # Interval in seconds to check for new mails (defaults to 10minutes)
#IMAP_ALLOW_OVERRIDE=true # Attributes writable (true for all), comma-separated list as specified in allow_override c
```
