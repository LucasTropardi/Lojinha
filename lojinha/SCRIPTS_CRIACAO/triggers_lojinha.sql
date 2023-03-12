use lojinha;

DELIMITER //
CREATE TRIGGER Tgr_insert_status_ped AFTER INSERT
ON pedidos
FOR EACH ROW
BEGIN
	insert into rastreabilidade values (new.num_pedido,new.status_ped,now(),user());
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER Tgr_update_status_ped AFTER UPDATE
ON pedidos
FOR EACH ROW
BEGIN
	insert into rastreabilidade values (new.num_pedido,new.status_ped,now(),user());
END//
DELIMITER ;