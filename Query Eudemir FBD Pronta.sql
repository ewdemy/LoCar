create table carro(idcarro serial, 
	modelo varchar(45) not null,
	marca varchar(45), 
	placa varchar(7) not null, 
	ano int, 
	precodiaria real not null, 
	status varchar(15) default 'DISPONIVEL', 
	constraint pkcarro primary key(idcarro), 
	constraint unplaca unique(placa));


create table cliente(idcliente serial, 
	nome varchar(50) not null, 
	cpf varchar(11) not null,
	datanasc date not null, 
	rua varchar(45),
	numero int, 
	bairro varchar(45), 
	cidade varchar(45), 
	telefone varchar(15),
	constraint pkcliente primary key(idcliente), 
	constraint uncpf unique(cpf));




create table locacao(idlocacao serial, 
	idcliente int not null, 
	idcarro int not null,
	datalocacao date not null, 
	dataentrega date not null, 
	status varchar(15) default 'ATIVO',
	constraint pklocacao primary key(idlocacao), 
	constraint fkcarro foreign key (idcarro)references carro(idcarro), 
	constraint fkcliente foreign key(idcliente) references cliente(idcliente));



create view notafiscal as select row_number() over (order by L.idlocacao) as id,L.idlocacao,
	CL.nome, 
	CL.cpf, 
	CA.modelo, 
	CA.ano, 
	CA.placa, 
	L.datalocacao, 
	L.dataentrega,
	(select(L.dataentrega) - (L.datalocacao)) as dias, 
	CA.precodiaria, 
	(select(L.dataentrega) - (L.datalocacao)) * CA.precodiaria as valortotal  from locacao L inner join carro CA on L.idcarro = CA.idcarro inner join cliente CL on L.idcliente=CL.idcliente order by idlocacao asc;





create or replace function delCarro()returns trigger as $$
begin

	delete from locacao where idcarro = old.idcarro;
	return old;

end;
$$ language plpgsql;


create trigger trigDelCarro
before delete on carro
for each row
execute procedure delCarro();


create or replace function delCliente()returns trigger as $$
begin

	delete from locacao where idcliente = old.idcliente;
	return old;

end;
$$ language plpgsql;


create trigger trigDelCliente
before delete on cliente
for each row
execute procedure delCliente();



