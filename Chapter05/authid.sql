/*File name authid.sql */
connect plsql9i/plsql9i;

Create or replace Procedure create_dyn_table
			    (i_region_name VARCHAR2,
			     retcd OUT NUMBER,
                             errmsg OUT VARCHAR2)
authid current_user
is
  cur_id INTEGER;
  ret_code INTEGER;
  dyn_string VARCHAR2(1000);
  dyn_Table_name VARCHAR2(21);
Begin
  dyn_table_name :=‘ORDERS_FOR_’||i_region_name;
  dyn_string :=‘CREATE TABLE ‘||dyn_table_name||
  ‘(order_id NUMBER(10)PRIMARY KEY,
    order_date DATE NOT NULL,
    total_qty NUMBER,
    total_price NUMBER(15,2))’;
    cur_id :=DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(cur_id,dyn_string,DBMS_SQL.V7);
    ret_code :=DBMS_SQL.EXECUTE(cur_id);
    DBMS_SQL.CLOSE_CURSOR(cur_id);
    retcd :=0;
EXCEPTION WHEN OTHERS THEN
  retcd :=SQLCODE;
  errmsg :=‘ERR:Creating table ‘||dyn_table_name ||’-‘||SQLERRM;
End;
/
grant execute on create_dyn_table to public;
connect region1/region1;
create synonym create_dyn_table for plsql9i.create_dyn_table;
declare
  retcd NUMBER;
  errmsg VARCHAR2(100);
begin
  create_dyn_table(‘REGION1’,retcd,errmsg);
end;
/
select table_name from user_tables where table_name like ‘%REGION1’;
connect region2/region2;
create synonym create_dyn_table for plsql9i.create_dyn_table;
declare
  retcd NUMBER;
  errmsg VARCHAR2(100);
begin
  create_dyn_table(‘REGION2’,retcd,errmsg);
end;
/
select table_name from user_tables where table_name like ‘%REGION2’;
