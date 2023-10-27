# omnici crontab entries on server host

    #@hourly find /prj/omnicast/Users/omnici/teamcity -mindepth 1 -maxdepth 1 -mtime +0 -type d -exec rm -r {} \;
    #@weekly docker exec -it server_omnici curl --basic --user 'omnici:<OMNICI_PASSWORD>' -X POST "https://omni-bld-tc01:8543/httpAuth/app/rest/server/backup?addTimestamp=true&includeConfigs=true&includeDatabase=true&includeBuildLogs=true&includePersonalChanges=true&fileName=TeamCity_Backup"
    @daily find /local/mnt/workspace2/teamcity/backups -mtime +15 -delete
    @weekly df -H /prj/omnicast /prj/omnicast_XR /prj/blurit /prj/omnilin | mailx -r nobody@qti.qualcomm.com -s 'omnicast disk usage update' omnicast.storage.admins@qti.qualcomm.com
    @daily rsync -a --del /local/mnt/workspace2/teamcity/artifacts/ /prj/omnicast_XR/Users/omnici/artifacts-target
    @daily rsync -a --del /local/mnt/workspace2/teamcity/backups/ /prj/omnicast_XR/Users/omnici/tc-backups

