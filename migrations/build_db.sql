create schema if not exists memleak;

create table if not exists memleak.domain(
    id serial primary key,
    name text not null
);
create table if not exists memleak.myuser(
    id serial primary key,
    name text not null,
    domain_id integer not null references memleak.domain(id)
);
create table if not exists memleak.customer(
    id serial primary key,
    "name" text not null,
    creator_id integer not null references memleak.myuser(id),
    description_md text
);

create table if not exists memleak.item(
    id serial primary key,
    "name" text not null,
    customer_id integer not null references memleak.customer(id),
    description_md text
);

create table if not exists memleak.inventory(
    id serial primary key,
    "name" text not null

);

create table if not exists memleak.inventory_item(
    id serial primary key,
    inventory_id integer not null references memleak.inventory(id),
    item_id integer not null references memleak.item(id)
);

create table if not exists memleak.inventory_domain(
    id serial primary key,
    inventory_id integer not null references memleak.inventory(id),
    domain_id integer not null references memleak.domain(id)
);