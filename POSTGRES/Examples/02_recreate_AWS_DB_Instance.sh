DB_INSTANCE="xbsinstance"
DB_SNAPSHOT="bigsnapshot"
DB_REGION="eu-central-1"
DB_SG="sg-a46e2fc8"


echo
echo "   Delete current DB instance"
echo
aws rds delete-db-instance --db-instance-identifier ${DB_INSTANCE} --region ${DB_REGION} --skip-final-snapshot

echo
echo "   Waiting while current DB instance is deleted ..."
echo
aws rds wait db-instance-deleted --db-instance-identifier ${DB_INSTANCE} --region ${DB_REGION}

echo
echo "   Restore DB instance from snapshot"
echo
aws rds restore-db-instance-from-db-snapshot \
--db-instance-identifier ${DB_INSTANCE} \
--db-snapshot-identifier ${DB_SNAPSHOT} \
--region ${DB_REGION}

echo
echo "   Waiting while current DB instance is restored ..."
echo
aws rds wait db-instance-available --db-instance-identifier ${DB_INSTANCE} --region ${DB_REGION}

echo
echo "   Modify DB instance"
echo
aws rds modify-db-instance --db-instance-identifier ${DB_INSTANCE} --region ${DB_REGION} \
--vpc-security-group-ids ${DB_SG}

echo
echo "   DB IS RESTORED"
echo