CREATE OR REPLACE PROCEDURE xxintg_submit_request_set_ds (
    p_errbuf  OUT VARCHAR2,
    p_retcode OUT VARCHAR2
) IS

    v_request_set_exist BOOLEAN := false;
    req_id              INTEGER := 0;
    l_conc_prog_submit  BOOLEAN := false;
    srs_failed EXCEPTION;
    submitprog_failed EXCEPTION;
    submitset_failed EXCEPTION;
    l_start_date        VARCHAR2(250);
BEGIN
    v_request_set_exist := fnd_submit.set_request_set(application => 'PO', request_set => 'XXTEST_DS_2');
    IF ( NOT v_request_set_exist ) THEN
        RAISE srs_failed;
    END IF;
    fnd_file.put_line(fnd_file.log, 'Calling REQUEST SET first stage');
    l_conc_prog_submit := fnd_submit.submit_program('XXINTG', 'XXINTG_PRINT_HTML_DS', 'STAGE10');
    IF ( NOT l_conc_prog_submit ) THEN
        RAISE submitprog_failed;
    END IF;
    l_conc_prog_submit := fnd_submit.submit_program('XXINTG', 'XXINTG_PRINT_HTML_DS', 'STAGE20');
    IF ( NOT l_conc_prog_submit ) THEN
        RAISE submitprog_failed;
    END IF;
    l_conc_prog_submit := fnd_submit.submit_program('XXINTG', 'XXINTG_PRINT_HTML_DS', 'STAGE30');
    IF ( NOT l_conc_prog_submit ) THEN
        RAISE submitprog_failed;
    END IF;
    fnd_file.put_line(fnd_file.log, 'Calling submit_set');
    SELECT
        to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS')
    INTO l_start_date
    FROM
        dual;

    req_id := fnd_submit.submit_set(start_time => l_start_date, sub_request => false);
    IF ( req_id = 0 ) THEN
        RAISE submitset_failed;
    END IF;
EXCEPTION
    WHEN srs_failed THEN
        p_errbuf := 'Call to set_request_set failed: ' || fnd_message.get;
        p_retcode := 2;
        fnd_file.put_line(fnd_file.log, p_errbuf);
    WHEN submitprog_failed THEN
        p_errbuf := 'Call to submit_program failed: ' || fnd_message.get;
        p_retcode := 2;
        fnd_file.put_line(fnd_file.log, p_errbuf);
    WHEN submitset_failed THEN
        p_errbuf := 'Call to submit_set failed: ' || fnd_message.get;
        p_retcode := 2;
        fnd_file.put_line(fnd_file.log, p_errbuf);
    WHEN OTHERS THEN
        p_errbuf := 'Request set submission failed – unknown error: ' || sqlerrm;
        p_retcode := 2;
        fnd_file.put_line(fnd_file.log, p_errbuf);
END;