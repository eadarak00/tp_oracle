Create Global Script global_full_backup 
{ 
    BACKUP Database PLUS Archivelog ; 
    Delete Obsolete ; 
}