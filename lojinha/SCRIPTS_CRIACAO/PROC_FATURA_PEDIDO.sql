-- drop procedure proc_fat_pedido
-- fecha o carriho, gera pedido
DELIMITER //
create procedure proc_fat_pedido (v_num_ped int,
								          OUT resposta VARCHAR(255))
main: begin
        DECLARE cod_erro CHAR(5) DEFAULT '00000';
	     DECLARE msg TEXT;
        DECLARE v_num_nf int;
        DECLARE v_qtde int;
        DECLARE v_id_prod int;
	     DECLARE raws INT;
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
   BEGIN
		GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
 		@nroerro = MYSQL_ERRNO, @msgerro = MESSAGE_TEXT;
		SET @msg_erro_completa = CONCAT("ERRO: ", @nroerro, " (", @sqlstate, "): ", @msgerro);
		SELECT @msg_erro_completa;
  END; 

  IF (select count(*) from pedidos where num_pedido=v_num_ped 
  and status_ped in ('F','T','E'))>0 then
  SET resposta='Pedido Ja Faturado';
		LEAVE main;
  END IF;
	-- inicia a transacao
    START TRANSACTION;
    
    -- lendo pedido e inserindo nfe
    insert into nota_fiscal (num_ped_ref,id_cliente,id_endereco,id_pgto,
                             total_prod,total_frete,total_desc,total_nf,
                             data_nf,status_nf,id_user)
    select num_pedido,id_cliente,id_endereco,id_pgto,total_prod,total_frete,
           total_desc,total_pedido,now(),'N',user()
    from pedidos
    where num_pedido=v_num_ped;
    -- pegando numero da nfe
    set v_num_nf=LAST_INSERT_ID();
    
    -- lendo pedido itens e inserindo nota itens
    
      insert into nf_itens
      (num_nota,id_produto,qtde,val_unit,desconto,total)
      select v_num_nf,id_produto,qtde,val_unit,desconto,total
      from pedido_itens
      where num_pedido=v_num_ped;
    
    -- Atualizando status ped
      UPDATE PEDIDOS SET status_ped='F'
	   where num_pedido=v_num_ped;
      
-- atualizando estoque
	-- atualizando estoque,
 
	UPDATE estoque
        INNER JOIN
    pedido_itens 
	    ON estoque.id_produto = pedido_itens.id_produto 
SET estoque.estoque_total = estoque.estoque_total - pedido_itens.qtde,
    estoque.estoque_reservado = estoque.estoque_reservado - pedido_itens.qtde
WHERE
    pedido_itens.num_pedido = v_num_ped;
    
-- checando excessao com IF

 IF cod_erro = '00000' THEN
    	  GET DIAGNOSTICS raws = ROW_COUNT;
		  SET resposta = CONCAT('Atualizacao com Sucesso  = ',raws);
          commit;
	ELSE
		SET resposta = CONCAT('Erro na atualizacao, error = ',raws,cod_erro,', message = ',msg);
        rollback;
  END IF;
   
  select concat('resposta ',resposta)
  union all
  SELECT concat('cod_erro ',cod_erro);
	
END//
DELIMITER ;


-- variaveis da procedure
-- v_pedido
-- OUT resposta VARCHAR(50))
call proc_fat_pedido(2,@resposta);
select @resposta;

select * from carrinho_compras;
select * from estoque;
select * from pedidos;
select * from pedido_itens;
select * from rastreabilidade order by 1;
select * from nota_fiscal;
select * from nf_itens;


