<?php

/**
 * Užsakymų redagavimo klasė
 *
 * @author MK
 */

class Uzsakymas {

	public function __construct() {
		
	}
	
	/**
	 * Užsakymo išrinkimas
	 * @param type $id
	 * @return type
	 */
	public function getUzsakymas($id) {
		$query = "  SELECT `Uzsakymas`.`uzsakymoNumeris`,
						   `Uzsakymas`.`uzsakymoData`,
						   `Uzsakymas`.`nuolaida`,
						   `Uzsakymas`.`nuolaidosKodas`,
						   `Uzsakymas`.`transportavimoKaina`,
						   `Uzsakymas`.`prekiuKiekis`,
						   `Uzsakymas`.`pristatymoBudas`,
						   `Uzsakymas`.`fk_AptarnaujantisAsistentastabelioNr`,
						   `Uzsakymas`.`fk_Pirkejaskodas`
					FROM `Uzsakymas`
					WHERE `Uzsakymas`.`uzsakymoNumeris`='{$id}'";
		$data = mysql::select($query);
		if (empty($data))
			return null;
		return $data[0];
	}
	
	/**
	 * Užsakymo atnaujinimas
	 * @param type $data
	 */
	public function updateUzsakymas($data) {
		$query = "  UPDATE `Uzsakymas`
					SET    `uzsakymoData`='{$data['uzsakymoData']}',
						   `nuolaida`='{$data['nuolaida']}',
						   `nuolaidosKodas`='{$data['nuolaidosKodas']}',
						   `transportavimoKaina`='{$data['transportavimoKaina']}',
						   `prekiuKiekis`='{$data['prekiuKiekis']}',
						   `pristatymoBudas`='{$data['pristatymoBudas']}',
						   `fk_AptarnaujantisAsistentastabelioNr`='{$data['fk_AptarnaujantisAsistentastabelioNr']}',
						   `fk_Pirkejaskodas`='{$data['fk_Pirkejaskodas']}'
					WHERE `uzsakymoNumeris`='{$data['uzsakymoNumeris']}'";
		mysql::query($query);
	}

	/**
	 * Užsakymo įrašymas
	 * @param type $data
	 */
	public function insertUzsakymas($data) {
		$query = "  INSERT INTO `Uzsakymas` 
								(
									`uzsakymoNumeris`,
									`uzsakymoData`,
									`nuolaida`,
									`nuolaidosKodas`,
									`transportavimoKaina`,
									`prekiuKiekis`,
									`pristatymoBudas`,
									`fk_AptarnaujantisAsistentastabelioNr`,
									`fk_Pirkejaskodas`
								) 
								VALUES
								(
									'{$data['uzsakymoNumeris']}',
									'{$data['uzsakymoData']}',
									'{$data['nuolaida']}',
									'{$data['nuolaidosKodas']}',
									'{$data['transportavimoKaina']}',
									'{$data['prekiuKiekis']}',
									'{$data['pristatymoBudas']}',
									'{$data['fk_AptarnaujantisAsistentastabelioNr']}',
									'{$data['fk_Pirkejaskodas']}'
								)";
		mysql::query($query);
	}
	
	/** 
	 * Užsakymų sąrašo išrinkimas
	 * @param type $limit
	 * @param type $offset
	 * @return type
	 */
	public function getUzsakymasList($limit = null, $offset = null) {
		$limitOffsetString = "";
		if(isset($limit)) {
			$limitOffsetString .= " LIMIT {$limit}";
		}
		if(isset($offset)) {
			$limitOffsetString .= " OFFSET {$offset}";
		}
		
		$query = "  SELECT `Uzsakymas`.`uzsakymoNumeris`,
						   `Pirkejas`.`kodas` AS `pirkejas`,
						   `AptarnaujantisAsistentas`.`tabelioNr` AS `aptarnaujantisAsistentas`,
						   `PristatymoBudas`.`name` AS `pristatymoBudas`
					FROM `Uzsakymas`
						LEFT JOIN `Pirkejas`
							ON `Uzsakymas`.`fk_Pirkejaskodas`=`Pirkejas`.`kodas`
						LEFT JOIN `AptarnaujantisAsistentas`
							ON `Uzsakymas`.`fk_AptarnaujantisAsistentastabelioNr`=`AptarnaujantisAsistentas`.`tabelioNr` 
						LEFT JOIN `PristatymoBudas`
							ON `Uzsakymas`.`pristatymoBudas`=`PristatymoBudas`.`id` " . $limitOffsetString;
		$data = mysql::select($query);
		
		return $data;
	}

	/** 
	 * Užsakymų kiekio radimas
	 * @return type
	 */
	public function getUzsakymasListCount() {
		$query = "  SELECT COUNT(`uzsakymoNumeris`) as `kiekis`
					FROM `Uzsakymas`";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Užsakymo šalinimas
	 * @param type $id
	 */
	public function deleteUzsakymas($id) {
		$query = "  DELETE FROM `Uzsakymas`
					WHERE `uzsakymoNumeris`='{$id}'";
		mysql::query($query);
	}
	
	/**
	 * Pristatymo būdų sąrašo išrinkimas
	 * @return type
	 */
	public function getPristatymoBudasList() {
		$query = "  SELECT *
					FROM `PristatymoBudas`";
		$data = mysql::select($query);
		
		return $data;
	}
	
	public function getPrekeList() {
		$query = "  SELECT *
					FROM `Preke`";
		$data = mysql::select($query);
		
		return $data;
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
	 * Asistentų sąrašo išrinkimas
	 * @return type
	 */
	public function getAsistentasList() {
		$query = "  SELECT *
					FROM `AptarnaujantisAsistentas`";
		$data = mysql::select($query);
		
		return $data;
	}
	
	public function deleteUzsakymoPreke($contractId, $clause = "") {
		$query = "  DELETE FROM `UzsakymoPreke`
					WHERE `fk_UzsakymasuzsakymoNumeris`='{$contractId}'" . $clause;
		mysql::query($query);
	}
	
	public function getMaxIdOfUzsakymoPreke() {
		$query = "  SELECT MAX(`id`) AS `latestId`
					FROM `UzsakymoPreke`";
		$data = mysql::select($query);
		
		return $data[0]['latestId'];
	}
	
	public function exists($val, $data, $key){
		$query = "	SELECT COUNT(1) as `kiekis`
					FROM `UzsakymoPreke`
					WHERE `UzsakymoPreke`.`fk_UzsakymasuzsakymoNumeris`= '{$data['uzsakymoNumeris']}' 
						AND `UzsakymoPreke`.`fk_Prekekodas` = '{$val}'
						AND `UzsakymoPreke`.`kiekis` = '{$data['kiekiai'][$key]}'";
		$data = mysql::select($query);
		return $data[0]['kiekis'];
	}
	
	public function insertUzsakymoPreke($data) {
		if(isset($data['uzsakymoPreke'])) {
			foreach($data['uzsakymoPreke'] as $key=>$val) {
				if($data['neaktyvus'] == array() || $data['neaktyvus'][$key] == 0) {
					$kiekis = $this->exists($val, $data, $key);
					if ($kiekis == 0){
						$latestId = $this->getMaxIdOfUzsakymoPreke();
						$data['idk'][$key] = $latestId + 1;
						$query = "  INSERT INTO `UzsakymoPreke`
											(
												`fk_UzsakymasuzsakymoNumeris`,
												`fk_Prekekodas`,
												`kiekis`,
												`id`
											)
											VALUES
											(
												'{$data['uzsakymoNumeris']}',
												'{$val}',
												'{$data['kiekiai'][$key]}',
												'{$data['idk'][$key]}'
											)";
						mysql::query($query);
					}
				}
			}
		}
	}
	
	public function getUzsakymoPreke($orderId) {
		$query = "  SELECT *
					FROM `UzsakymoPreke`
					WHERE `fk_UzsakymasuzsakymoNumeris`='{$orderId}'";
		$data = mysql::select($query);
		
		return $data;
	}
	
	public function getSaskaitaCountOfAptarnaujantisAsistentas($id) {
		$query = "  SELECT COUNT(`Uzsakymas`.`uzsakymoNumeris`) AS `kiekis`
					FROM `UzsakymoPreke`
						INNER JOIN `Uzsakymas`
							ON `Uzsakymas`.`uzsakymoNumeris`=`UzsakymoPreke`.`fk_UzsakymasuzsakymoNumeris`
					WHERE `Uzsakymas`.`uzsakymoNumeris`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	public function getSiuntosCount($id) {
		$query = "  SELECT COUNT(`Uzsakymas`.`uzsakymoNumeris`) AS `kiekis`
					FROM `Siunta`
						INNER JOIN `Uzsakymas`
							ON `Uzsakymas`.`uzsakymoNumeris`=`Siunta`.`fk_UzsakymasuzsakymoNumeris`
					WHERE `Uzsakymas`.`uzsakymoNumeris`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	public function getUzsakymoPrekeCount($id){
		$query = "	SELECT COUNT(1) as `kiekis`
					FROM `UzsakymoPreke`
					WHERE `UzsakymoPreke`.`fk_UzsakymasuzsakymoNumeris` = '{$id}'";
		$data = mysql::select($query);
		return $data[0]['kiekis'];
	}
}