Create Script full_backup 
{
    BACKUP Database PLUS Archivelog ; 
    Delete Obsolete ;
}