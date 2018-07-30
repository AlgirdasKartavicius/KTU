<?php

/**
 * Pristato siuntą redagavimo klasė
 *
 * @author MK
 */

class PristatoSiunta {

	public function __construct() {
		
	}
	
	/**
	 * Pristato siuntą išrinkimas
	 * @param type $id
	 * @return type
	 */
	public function getPristatoSiunta($id) {
		$query = "  SELECT `PristatoSiunta`.`fk_Pirkejaskodas`,
						   `PristatoSiunta`.`fk_SiuntuPervezimoTarnybaid`,
						   `PristatoSiunta`.`id`
					FROM `PristatoSiunta`
					WHERE `PristatoSiunta`.`id`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0];
	}
	
	/**
	 * Pristato siuntą atnaujinimas
	 * @param type $data
	 */
	public function updatePristatoSiunta($data) {
		$query = "  UPDATE `PristatoSiunta`
					SET    `fk_Pirkejaskodas`='{$data['fk_Pirkejaskodas']}',
						   `fk_SiuntuPervezimoTarnybaid`='{$data['fk_SiuntuPervezimoTarnybaid']}'
					WHERE `id`='{$data['id']}'";
		mysql::query($query);
	}

	/**
	 * Pristato siuntą įrašymas
	 * @param type $data
	 */
	public function insertPristatoSiunta($data) {
		$query = "  INSERT INTO `PristatoSiunta` 
								(
									`fk_Pirkejaskodas`,
									`fk_SiuntuPervezimoTarnybaid`,
									`id`
								) 
								VALUES
								(
									'{$data['fk_Pirkejaskodas']}',
									'{$data['fk_SiuntuPervezimoTarnybaid']}',
									'{$data['id']}'
								)";
		mysql::query($query);
	}
	
	/** 
	 * Pristato siuntą sąrašo išrinkimas
	 * @param type $limit
	 * @param type $offset
	 * @return type
	 */
	public function getPristatoSiuntaList($limit = null, $offset = null) {
		$limitOffsetString = "";
		if(isset($limit)) {
			$limitOffsetString .= " LIMIT {$limit}";
		}
		if(isset($offset)) {
			$limitOffsetString .= " OFFSET {$offset}";
		}
		
		$query = "  SELECT `PristatoSiunta`.`id`,
						   `Pirkejas`.`kodas` AS `pirkejas`,
						   `SiuntuPervezimoTarnyba`.`pavadinimas` AS `tarnyba`
					FROM `PristatoSiunta`
							LEFT JOIN `SiuntuPervezimoTarnyba`
								ON `PristatoSiunta`.`fk_SiuntuPervezimoTarnybaid`=`SiuntuPervezimoTarnyba`.`id`
							LEFT JOIN `Pirkejas`
								ON `PristatoSiunta`.`fk_Pirkejaskodas`=`Pirkejas`.`kodas` " . $limitOffsetString;
		$data = mysql::select($query);
		
		return $data;
	}

	/** 
	 * Pristato siuntą kiekio radimas
	 * @return type
	 */
	public function getPristatoSiuntaListCount() {
		$query = "  SELECT COUNT(`id`) as `kiekis`
					FROM `PristatoSiunta`";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Pristato siuntą šalinimas
	 * @param type $id
	 */
	public function deletePristatoSiunta($id) {
		$query = "  DELETE FROM `PristatoSiunta`
					WHERE `id`='{$id}'";
		mysql::query($query);
	}
	
	/**
	 * Pirkėjų sąrašo išrinkimas
	 * @return type
	 */
	public function getPirkejasList() {
		$query = "  SELECT *
					FROM `Pirkejas`";
		$data = mysql::select($query);
		
		return $data;
	}
	/**
	 * Tarnybų sąrašo išrinkimas
	 * @return type
	 */
	public function getSiuntuPervezimoTarnybaList() {
		$query = "  SELECT *
					FROM `SiuntuPervezimoTarnyba`";
		$data = mysql::select($query);
		
		return $data;
	}
	
	/**
	 * Didžiausiausios Pristato siuntą id reikšmės radimas
	 * @return type
	 */
	public function getMaxIdOfPristatoSiunta() {
		$query = "  SELECT MAX(`id`) AS `latestId`
					FROM `PristatoSiunta`";
		$data = mysql::select($query);
		
		return $data[0]['latestId'];
	}
}