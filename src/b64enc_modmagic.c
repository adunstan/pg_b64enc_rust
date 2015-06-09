#include "postgres.h"
#include "fmgr.h"

PG_MODULE_MAGIC;

extern void b64enc_report_error(int error_code, char *message, char *arg);
extern void b64enc_send_error(char *message);
extern void b64enc_send_notice(char *message);

void
b64enc_report_error(int error_code, char *message, char *arg)
{
    if (arg != NULL)
        ereport(ERROR,
                (errcode(error_code),
                 errmsg(message, arg)
                 ));
    else
        ereport(ERROR,
                (errcode(error_code),
                 message
                 ));
}


void
b64enc_send_error(char *message)
{
	elog(ERROR,"%s",message);
}

void
b64enc_send_notice(char *message)
{
	elog(NOTICE,"%s",message);
}

