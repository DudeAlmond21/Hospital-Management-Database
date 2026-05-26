create database if not exists hospital_db;
use hospital_db;


create table departments (
    department_id int auto_increment primary key,
    name varchar(100) not null unique,
    floor int not null,
    head_doctor_id int default null
);

create table patients (
    patient_id int auto_increment primary key,
    full_name varchar(100) not null,
    dob date not null,
    gender enum('male','female','other') not null,
    blood_group enum('a+','a-','b+','b-','ab+','ab-','o+','o-'),
    phone varchar(15) unique not null,
    email varchar(100) unique,
    address text,
    emergency_contact varchar(15),
    registered_at timestamp default current_timestamp
);

create table doctors (
    doctor_id int auto_increment primary key,
    full_name varchar(100) not null,
    specialization varchar(100) not null,
    department_id int not null,
    phone varchar(15) unique not null,
    email varchar(100) unique,
    available_days varchar(50) default 'mon,tue,wed,thu,fri',
    foreign key (department_id) references departments(department_id)
);

alter table departments
    add constraint fk_head_doctor
    foreign key (head_doctor_id) references doctors(doctor_id);

create table rooms (
    room_id int auto_increment primary key,
    room_number varchar(10) unique not null,
    type enum('general','private','icu','operation') not null,
    floor int not null,
    status enum('available','occupied','maintenance') default 'available',
    daily_rate decimal(10,2) not null
);

create table appointments (
    appointment_id int auto_increment primary key,
    patient_id int not null,
    doctor_id int not null,
    appointment_date datetime not null,
    reason varchar(255),
    status enum('scheduled','completed','cancelled','no_show') default 'scheduled',
    room_id int default null,
    created_at timestamp default current_timestamp,
    foreign key (patient_id) references patients(patient_id) on delete cascade,
    foreign key (doctor_id) references doctors(doctor_id),
    foreign key (room_id) references rooms(room_id)
);

create table medical_records (
    record_id int auto_increment primary key,
    appointment_id int not null unique,
    diagnosis text not null,
    notes text,
    follow_up_date date,
    recorded_at timestamp default current_timestamp,
    foreign key (appointment_id) references appointments(appointment_id) on delete cascade
);

create table prescriptions (
    prescription_id int auto_increment primary key,
    appointment_id int not null,
    issued_at timestamp default current_timestamp,
    foreign key (appointment_id) references appointments(appointment_id) on delete cascade
);

create table prescription_items (
    item_id int auto_increment primary key,
    prescription_id int not null,
    medication varchar(100) not null,
    dosage varchar(50) not null,
    frequency varchar(50) not null,
    duration_days int not null,
    foreign key (prescription_id) references prescriptions(prescription_id) on delete cascade
);

create table billing (
    bill_id int auto_increment primary key,
    patient_id int not null,
    appointment_id int not null unique,
    subtotal decimal(10,2) default 0.00,
    tax decimal(10,2) default 0.00,
    total decimal(10,2) default 0.00,
    status enum('pending','paid','overdue','waived') default 'pending',
    issued_date date not null,
    due_date date not null,
    paid_at timestamp null,
    foreign key (patient_id) references patients(patient_id),
    foreign key (appointment_id) references appointments(appointment_id)
);

create table billing_items (
    item_id int auto_increment primary key,
    bill_id int not null,
    description varchar(150) not null,
    amount decimal(10,2) not null,
    foreign key (bill_id) references billing(bill_id) on delete cascade
);

create table staff (
    staff_id int auto_increment primary key,
    full_name varchar(100) not null,
    role enum('nurse','receptionist','admin','lab_technician') not null,
    department_id int,
    phone varchar(15) unique not null,
    shift enum('morning','evening','night') default 'morning',
    foreign key (department_id) references departments(department_id)
);

create table audit_log (
    log_id int auto_increment primary key,
    action_type enum('insert','update','delete') not null,
    table_name varchar(50) not null,
    record_id int,
    performed_by varchar(100) default (user()),
    changed_at timestamp default current_timestamp,
    details text
);


insert into departments (name, floor) values
('cardiology', 3),
('orthopedics', 2),
('neurology', 4),
('general medicine', 1),
('icu', 5);

insert into patients (full_name, dob, gender, blood_group, phone, email, address, emergency_contact) values
('arun kumar',    '1990-04-12', 'male',   'b+', '9876543210', 'arun@email.com',   '12 anna nagar, chennai',    '9876500001'),
('priya nair',    '1985-07-23', 'female', 'o+', '9876543211', 'priya@email.com',  '5 mg road, bangalore',      '9876500002'),
('rahul verma',   '2000-01-05', 'male',   'a+', '9876543212', 'rahul@email.com',  '88 sector 15, noida',       '9876500003'),
('sneha rao',     '1978-11-30', 'female', 'ab+','9876543213', 'sneha@email.com',  '3 banjara hills, hyderabad','9876500004'),
('karthik m',     '1995-03-18', 'male',   'o-', '9876543214', 'karthik@email.com','45 t nagar, chennai',       '9876500005'),
('divya suresh',  '2002-09-09', 'female', 'b-', '9876543215', 'divya@email.com',  '22 koregaon park, pune',    '9876500006'),
('arjun mehta',   '1969-12-01', 'male',   'a-', '9876543216', 'arjun@email.com',  '7 civil lines, delhi',      '9876500007'),
('lakshmi p',     '1993-06-14', 'female', 'o+', '9876543217', 'lakshmi@email.com','99 adyar, chennai',         '9876500008');

insert into doctors (full_name, specialization, department_id, phone, email) values
('dr. meena iyer',   'cardiologist',     1, '9000000001', 'meena@hospital.com'),
('dr. suresh babu',  'orthopedic',       2, '9000000002', 'suresh@hospital.com'),
('dr. anita shah',   'neurologist',      3, '9000000003', 'anita@hospital.com'),
('dr. ramesh g',     'general physician',4, '9000000004', 'ramesh@hospital.com'),
('dr. kavitha r',    'intensivist',      5, '9000000005', 'kavitha@hospital.com');

update departments set head_doctor_id = 1 where department_id = 1;
update departments set head_doctor_id = 2 where department_id = 2;
update departments set head_doctor_id = 3 where department_id = 3;
update departments set head_doctor_id = 4 where department_id = 4;
update departments set head_doctor_id = 5 where department_id = 5;

insert into rooms (room_number, type, floor, status, daily_rate) values
('101', 'general',   1, 'available', 1000.00),
('201', 'private',   2, 'occupied',  2500.00),
('301', 'general',   3, 'available', 1000.00),
('401', 'icu',       4, 'occupied',  8000.00),
('501', 'operation', 5, 'available', 15000.00);

insert into appointments (patient_id, doctor_id, appointment_date, reason, status, room_id) values
(1, 1, '2025-04-10 09:00:00', 'chest pain',             'completed', 2),
(2, 2, '2025-04-11 10:30:00', 'knee swelling',          'completed', null),
(3, 1, '2025-05-02 11:00:00', 'routine checkup',        'scheduled', null),
(4, 3, '2025-05-03 14:00:00', 'recurring migraines',    'scheduled', null),
(5, 2, '2025-04-09 08:00:00', 'lower back pain',        'cancelled', null),
(6, 4, '2025-04-20 09:30:00', 'fever and cough',        'completed', 1),
(7, 5, '2025-04-22 16:00:00', 'post surgery monitoring','completed', 4),
(8, 1, '2025-05-05 10:00:00', 'ecg follow up',          'scheduled', null);

insert into medical_records (appointment_id, diagnosis, notes, follow_up_date) values
(1, 'mild coronary artery disease', 'prescribed statins and aspirin. advised low fat diet.', '2025-05-10'),
(2, 'medial meniscus tear',         'physiotherapy recommended for 6 weeks.',                '2025-05-20'),
(6, 'viral upper respiratory infection', 'rest and fluids. antibiotics if no improvement.',  '2025-04-27'),
(7, 'stable post-operative recovery',    'vitals normal. reduce icu monitoring frequency.',  '2025-04-29');

insert into prescriptions (appointment_id) values (1), (2), (6);

insert into prescription_items (prescription_id, medication, dosage, frequency, duration_days) values
(1, 'atorvastatin', '10mg',  'once daily at night',  30),
(1, 'aspirin',      '75mg',  'once daily after food', 60),
(1, 'metoprolol',   '25mg',  'twice daily',           30),
(2, 'ibuprofen',    '400mg', 'thrice daily after food', 7),
(2, 'pantoprazole', '40mg',  'once daily before food', 7),
(3, 'paracetamol',  '500mg', 'thrice daily',           5),
(3, 'cetirizine',   '10mg',  'once daily at night',    5);

insert into billing (patient_id, appointment_id, subtotal, tax, total, status, issued_date, due_date) values
(1, 1, 2800.00, 504.00, 3304.00, 'paid',    '2025-04-10', '2025-04-20'),
(2, 2, 1800.00, 324.00, 2124.00, 'paid',    '2025-04-11', '2025-04-21'),
(6, 6, 900.00,  162.00, 1062.00, 'pending', '2025-04-20', '2025-04-30'),
(7, 7, 9500.00, 1710.00,11210.00,'pending', '2025-04-22', '2025-05-02');

insert into billing_items (bill_id, description, amount) values
(1, 'consultation fee - cardiology', 800.00),
(1, 'ecg',                           500.00),
(1, 'blood panel',                   700.00),
(1, 'room charges - 1 day private',  2500.00),
(2, 'consultation fee - orthopedic', 700.00),
(2, 'x-ray - knee',                  600.00),
(2, 'physiotherapy session',         500.00),
(3, 'consultation fee - general',    500.00),
(3, 'rapid antigen test',            400.00),
(4, 'icu charges - 1 day',           8000.00),
(4, 'specialist consultation',       1000.00),
(4, 'monitoring equipment',          500.00);

insert into staff (full_name, role, department_id, phone, shift) values
('mary thomas',  'nurse',          1, '8100000001', 'morning'),
('raj patel',    'receptionist',   4, '8100000002', 'morning'),
('sunita devi',  'admin',          4, '8100000003', 'evening'),
('vinod kumar',  'lab_technician', 4, '8100000004', 'morning'),
('asha menon',   'nurse',          5, '8100000005', 'night');


create index idx_appointment_date   on appointments(appointment_date);
create index idx_appointment_status on appointments(status);
create index idx_billing_status     on billing(status);
create index idx_billing_due        on billing(due_date);
create index idx_patient_phone      on patients(phone);
create index idx_patient_name       on patients(full_name);
create index idx_doctor_dept        on doctors(department_id);


create view doctor_schedule as
select
    a.appointment_id,
    d.full_name       as doctor_name,
    d.specialization,
    dep.name          as department,
    p.full_name       as patient_name,
    p.phone           as patient_phone,
    a.appointment_date,
    a.reason,
    a.status
from appointments a
join doctors     d   on a.doctor_id     = d.doctor_id
join departments dep on d.department_id = dep.department_id
join patients    p   on a.patient_id    = p.patient_id
order by a.appointment_date;

create view patient_full_history as
select
    p.patient_id,
    p.full_name                             as patient_name,
    p.blood_group,
    a.appointment_id,
    a.appointment_date,
    a.status                                as appointment_status,
    d.full_name                             as doctor_name,
    mr.diagnosis,
    mr.follow_up_date,
    b.total                                 as bill_total,
    b.status                                as bill_status
from patients    p
left join appointments   a  on p.patient_id      = a.patient_id
left join doctors        d  on a.doctor_id        = d.doctor_id
left join medical_records mr on a.appointment_id  = mr.appointment_id
left join billing         b  on a.appointment_id  = b.appointment_id
order by a.appointment_date desc;

create view overdue_bills as
select
    b.bill_id,
    p.full_name                           as patient_name,
    p.phone                               as patient_phone,
    b.total,
    b.due_date,
    datediff(curdate(), b.due_date)       as days_overdue,
    d.full_name                           as treating_doctor
from billing      b
join patients     p on b.patient_id     = p.patient_id
join appointments a on b.appointment_id = a.appointment_id
join doctors      d on a.doctor_id      = d.doctor_id
where b.status = 'pending'
  and b.due_date < curdate();

create view department_workload as
select
    dep.name                              as department,
    d.full_name                           as doctor,
    count(a.appointment_id)               as total_appointments,
    sum(a.status = 'completed')           as completed,
    sum(a.status = 'scheduled')           as upcoming,
    sum(a.status = 'cancelled')           as cancelled
from departments dep
join doctors      d  on dep.department_id = d.department_id
left join appointments a on d.doctor_id   = a.doctor_id
group by dep.name, d.full_name
order by total_appointments desc;

create view revenue_summary as
select
    dep.name                              as department,
    count(b.bill_id)                      as total_bills,
    sum(b.total)                          as total_revenue,
    sum(b.status = 'paid')                as paid_count,
    sum(case when b.status = 'paid'  then b.total else 0 end) as collected,
    sum(case when b.status != 'paid' then b.total else 0 end) as outstanding
from billing      b
join appointments a   on b.appointment_id  = a.appointment_id
join doctors      d   on a.doctor_id       = d.doctor_id
join departments  dep on d.department_id   = dep.department_id
group by dep.name;

create view patient_summary as
select
    p.patient_id,
    p.full_name,
    p.blood_group,
    count(distinct a.appointment_id)      as total_visits,
    count(distinct mr.record_id)          as diagnosed_cases,
    sum(b.total)                          as total_billed,
    sum(case when b.status = 'paid' then b.total else 0 end) as total_paid,
    sum(case when b.status != 'paid' then b.total else 0 end) as balance_due
from patients      p
left join appointments    a  on p.patient_id     = a.patient_id
left join medical_records mr on a.appointment_id = mr.appointment_id
left join billing          b on a.appointment_id = b.appointment_id
group by p.patient_id, p.full_name, p.blood_group;


delimiter //

create trigger trg_after_appointment_insert
after insert on appointments
for each row
begin
    insert into audit_log (action_type, table_name, record_id, details)
    values ('insert', 'appointments', new.appointment_id,
            concat('patient_id=', new.patient_id, ' doctor_id=', new.doctor_id,
                   ' date=', new.appointment_date));
end;//

create trigger trg_after_appointment_cancel
after update on appointments
for each row
begin
    if new.status = 'cancelled' and old.status != 'cancelled' then
        update billing
        set status = 'waived'
        where appointment_id = new.appointment_id
          and status = 'pending';
        insert into audit_log (action_type, table_name, record_id, details)
        values ('update', 'appointments', new.appointment_id,
                concat('status changed to cancelled. billing auto-waived.'));
    end if;
end;//

create trigger trg_before_billing_update
before update on billing
for each row
begin
    if new.status = 'pending' and new.due_date < curdate() then
        set new.status = 'overdue';
    end if;
    if new.status = 'paid' and old.status != 'paid' then
        set new.paid_at = current_timestamp;
    end if;
end;//

create trigger trg_after_patient_insert
after insert on patients
for each row
begin
    insert into audit_log (action_type, table_name, record_id, details)
    values ('insert', 'patients', new.patient_id,
            concat('registered: ', new.full_name, ' phone: ', new.phone));
end;//

create trigger trg_after_billing_insert
after insert on billing
for each row
begin
    insert into audit_log (action_type, table_name, record_id, details)
    values ('insert', 'billing', new.bill_id,
            concat('patient_id=', new.patient_id, ' total=', new.total, ' due=', new.due_date));
end;//


create procedure book_appointment(
    in p_patient_id   int,
    in p_doctor_id    int,
    in p_date         datetime,
    in p_reason       varchar(255),
    in p_subtotal     decimal(10,2),
    in p_due_date     date
)
begin
    declare v_appointment_id int;
    declare v_tax            decimal(10,2);
    declare v_total          decimal(10,2);
    declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;

    set v_tax   = round(p_subtotal * 0.18, 2);
    set v_total = p_subtotal + v_tax;

    start transaction;
        insert into appointments (patient_id, doctor_id, appointment_date, reason)
        values (p_patient_id, p_doctor_id, p_date, p_reason);

        set v_appointment_id = last_insert_id();

        insert into billing (patient_id, appointment_id, subtotal, tax, total, issued_date, due_date)
        values (p_patient_id, v_appointment_id, p_subtotal, v_tax, v_total, curdate(), p_due_date);
    commit;

    select v_appointment_id as appointment_id, v_total as total_billed;
end;//

create procedure discharge_patient(
    in p_appointment_id int
)
begin
    declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;

    start transaction;
        update appointments
        set status = 'completed'
        where appointment_id = p_appointment_id
          and status = 'scheduled';

        update billing
        set status = 'paid', paid_at = current_timestamp
        where appointment_id = p_appointment_id
          and status in ('pending','overdue');

        update rooms r
        join appointments a on a.room_id = r.room_id
        set r.status = 'available'
        where a.appointment_id = p_appointment_id;
    commit;

    select 'patient discharged successfully' as result;
end;//

create procedure process_payment(
    in p_bill_id int
)
begin
    declare v_status varchar(20);
    declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;

    select status into v_status from billing where bill_id = p_bill_id for update;

    if v_status = 'paid' then
        signal sqlstate '45000' set message_text = 'bill is already paid';
    end if;

    start transaction;
        update billing
        set status = 'paid', paid_at = current_timestamp
        where bill_id = p_bill_id;

        insert into audit_log (action_type, table_name, record_id, details)
        values ('update', 'billing', p_bill_id, 'payment processed');
    commit;

    select 'payment successful' as result;
end;//

create procedure get_patient_history(
    in p_patient_id int
)
begin
    select * from patient_full_history
    where patient_id = p_patient_id;
end;//

create procedure get_department_report(
    in p_department_name varchar(100)
)
begin
    select * from department_workload
    where department = p_department_name;

    select * from revenue_summary
    where department = p_department_name;
end;//


create function calculate_age(p_dob date)
returns int
deterministic
begin
    return timestampdiff(year, p_dob, curdate());
end;//

create function get_balance_due(p_patient_id int)
returns decimal(10,2)
reads sql data
begin
    declare v_balance decimal(10,2);
    select coalesce(sum(total), 0) into v_balance
    from billing
    where patient_id = p_patient_id
      and status in ('pending','overdue');
    return v_balance;
end;//

delimiter ;


create user if not exists 'doctor_user'@'localhost'       identified by 'Doc@1234';
create user if not exists 'receptionist_user'@'localhost' identified by 'Rec@1234';
create user if not exists 'billing_user'@'localhost'      identified by 'Bil@1234';
create user if not exists 'auditor_user'@'localhost'      identified by 'Aud@1234';

grant select                        on hospital_db.doctor_schedule      to 'doctor_user'@'localhost';
grant select                        on hospital_db.patient_full_history  to 'doctor_user'@'localhost';
grant select                        on hospital_db.prescriptions         to 'doctor_user'@'localhost';
grant select                        on hospital_db.prescription_items    to 'doctor_user'@'localhost';
grant select, insert, update        on hospital_db.medical_records       to 'doctor_user'@'localhost';
grant execute                       on procedure hospital_db.get_patient_history to 'doctor_user'@'localhost';

grant select                        on hospital_db.patients              to 'receptionist_user'@'localhost';
grant select, insert, update        on hospital_db.appointments          to 'receptionist_user'@'localhost';
grant select                        on hospital_db.doctor_schedule       to 'receptionist_user'@'localhost';
grant select                        on hospital_db.rooms                 to 'receptionist_user'@'localhost';
grant execute                       on procedure hospital_db.book_appointment to 'receptionist_user'@'localhost';
grant execute                       on procedure hospital_db.discharge_patient to 'receptionist_user'@'localhost';

grant select, update                on hospital_db.billing               to 'billing_user'@'localhost';
grant select                        on hospital_db.billing_items         to 'billing_user'@'localhost';
grant select                        on hospital_db.overdue_bills         to 'billing_user'@'localhost';
grant select                        on hospital_db.revenue_summary       to 'billing_user'@'localhost';
grant execute                       on procedure hospital_db.process_payment to 'billing_user'@'localhost';

grant select                        on hospital_db.audit_log             to 'auditor_user'@'localhost';
grant select                        on hospital_db.patient_summary       to 'auditor_user'@'localhost';
grant select                        on hospital_db.overdue_bills         to 'auditor_user'@'localhost';
grant select                        on hospital_db.revenue_summary       to 'auditor_user'@'localhost';

flush privileges;


call book_appointment(3, 3, '2025-05-10 09:00:00', 'neurology follow-up', 1500.00, '2025-05-20');
call book_appointment(8, 1, '2025-05-12 11:00:00', 'ecg and stress test',  2200.00, '2025-05-22');

call discharge_patient(6);
call discharge_patient(7);

call process_payment(3);

call get_patient_history(1);
call get_department_report('cardiology');


select calculate_age('1990-04-12') as patient_age;
select get_balance_due(4)          as amount_due_for_patient_4;

select * from doctor_schedule;
select * from overdue_bills;
select * from patient_summary;
select * from department_workload;
select * from revenue_summary;


explain select * from appointments where appointment_date = '2025-05-02 11:00:00';
explain select * from billing      where status = 'pending';
explain select * from patients     where phone = '9876543212';

explain
select p.full_name, a.appointment_date, b.total
from patients p
join appointments a on p.patient_id = a.patient_id
join billing      b on a.appointment_id = b.appointment_id
where b.status = 'pending'
  and a.appointment_date > curdate();


start transaction;
update billing set status = 'paid' where bill_id = 4;
update appointments set status = 'completed' where appointment_id = 7;
rollback;

select status from billing      where bill_id = 4;
select status from appointments where appointment_id = 7;


select * from audit_log order by changed_at desc;

show grants for 'doctor_user'@'localhost';
show grants for 'receptionist_user'@'localhost';
show grants for 'billing_user'@'localhost';
show grants for 'auditor_user'@'localhost';

select
    table_name,
    index_name,
    column_name,
    index_type
from information_schema.statistics
where table_schema = 'hospital_db'
order by table_name, index_name;
