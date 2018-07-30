<?php

/**
 * Siuntų redagavimo klasė
 *
 * @author MK
 */

class Siunta {

	public function __construct() {
		
	}
	
	/**
	 * Siuntos išrinkimas
	 * @param type $id
	 * @return type
	 */
	public function getSiunta($id) {
		$query = "  SELECT `Siunta`.`kodas`,
						   `Siunta`.`svoris`,
						   `Siunta`.`pristatymoData`,
						   `Siunta`.`gavejoAdresas`,
						   `Siunta`.`draudimoKaina`,
						   `Siunta`.`pakuotesDydis`,
						   `Siunta`.`fk_AptarnaujantisAsistentastabelioNr`,
						   `Siunta`.`fk_SiuntuPervezimoTarnybaid`,
						   `Siunta`.`fk_UzsakymasuzsakymoNumeris`,
						   `Siunta`.`fk_Pirkejaskodas`
					FROM `Siunta`
					WHERE `Siunta`.`kodas`='{$id}'";
		$data = mysql::select($query);
		if (empty($data))
			return null;
		return $data[0];
	}
	
	public function getUzsKiekis($val){
		$query = "	SELECT COUNT(1) as `kiekis`
					FROM `Siunta`
					WHERE `Siunta`.`fk_UzsakymasuzsakymoNumeris` = '{$val}'";
		$data = mysql::select($query);
		return $data[0]['kiekis'];
	}
	
	/**
	 * Siuntos atnaujinimas
	 * @param type $data
	 */
	public function updateSiunta($data) {
		$query = "  UPDATE `Siunta`
					SET    `kodas`='{$data['kodas']}',
						   `svoris`='{$data['svoris']}',
						   `pristatymoData`='{$data['pristatymoData']}',
						   `gavejoAdresas`='{$data['gavejoAdresas']}',
						   `draudimoKaina`='{$data['draudimoKaina']}',
						   `pakuotesDydis`='{$data['pakuotesDydis']}',
						   `fk_AptarnaujantisAsistentastabelioNr`='{$data['fk_AptarnaujantisAsistentastabelioNr']}',
						   `fk_SiuntuPervezimoTarnybaid`='{$data['fk_SiuntuPervezimoTarnybaid']}',
						   `fk_UzsakymasuzsakymoNumeris`='{$data['fk_UzsakymasuzsakymoNumeris']}',
						   `fk_Pirkejaskodas`='{$data['fk_Pirkejaskodas']}'
					WHERE `kodas`='{$data['kodas']}'";
		mysql::query($query);
	}

	/**
	 * Siuntos įrašymas
	 * @param type $data
	 */
	public function insertSiunta($data) {
		$query = "  INSERT INTO `Siunta` 
								(
									`kodas`,
									`svoris`,
									`pristatymoData`,
									`gavejoAdresas`,
									`draudimoKaina`,
									`pakuotesDydis`,
									`fk_AptarnaujantisAsistentastabelioNr`,
									`fk_SiuntuPervezimoTarnybaid`,
									`fk_UzsakymasuzsakymoNumeris`,
									`fk_Pirkejaskodas`
								) 
								VALUES
								(
									'{$data['kodas']}',
									'{$data['svoris']}',
									'{$data['pristatymoData']}',
									'{$data['gavejoAdresas']}',
									'{$data['draudimoKaina']}',
									'{$data['pakuotesDydis']}',
									'{$data['fk_AptarnaujantisAsistentastabelioNr']}',
									'{$data['fk_SiuntuPervezimoTarnybaid']}',
									'{$data['fk_UzsakymasuzsakymoNumeris']}',
									'{$data['fk_Pirkejaskodas']}'
								)";
		mysql::query($query);
	}
	
	/** 
	 * Siuntų sąrašo išrinkimas
	 * @param type $limit
	 * @param type $offset
	 * @return type
	 */
	public function getSiuntaList($limit = null, $offset = null) {
		$limitOffsetString = "";
		if(isset($limit)) {
			$limitOffsetString .= " LIMIT {$limit}";
		}
		if(isset($offset)) {
			$limitOffsetString .= " OFFSET {$offset}";
		}
		
		$query = "  SELECT `Siunta`.`kodas`,
						   `PakuotesDydis`.`name` AS `pakuotesDydis`,
						   `Pirkejas`.`kodas` AS `pirkejas`,
						   `AptarnaujantisAsistentas`.`tabelioNr` AS `aptarnaujantisAsistentas`,
						   `Uzsakymas`.`uzsakymoNumeris` AS `uzsakymas`,
						   `SiuntuPervezimoTarnyba`.`pavadinimas` AS `tarnyba`
					FROM `Siunta`
						LEFT JOIN `SiuntuPervezimoTarnyba`
							ON `Siunta`.`fk_SiuntuPervezimoTarnybaid`=`SiuntuPervezimoTarnyba`.`id`
						LEFT JOIN `PakuotesDydis`
							ON `Siunta`.`pakuotesDydis`=`PakuotesDydis`.`id`
						LEFT JOIN `Pirkejas`
							ON `Siunta`.`fk_Pirkejaskodas`=`Pirkejas`.`kodas`
						LEFT JOIN `AptarnaujantisAsistentas`
							ON `Siunta`.`fk_AptarnaujantisAsistentastabelioNr`=`AptarnaujantisAsistentas`.`tabelioNr` 
						LEFT JOIN `Uzsakymas`
							ON `Siunta`.`fk_UzsakymasuzsakymoNumeris`=`Uzsakymas`.`uzsakymoNumeris` " . $limitOffsetString;
		$data = mysql::select($query);
		
		return $data;
	}

	/** 
	 * Siuntų kiekio radimas
	 * @return type
	 */
	public function getSiuntaListCount() {
		$query = "  SELECT COUNT(`kodas`) as `kiekis`
					FROM `Siunta`";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Siuntos šalinimas
	 * @param type $id
	 */
	public function deleteSiunta($id) {
		$query = "  DELETE FROM `Siunta`
					WHERE `kodas`='{$id}'";
		mysql::query($query);
	}
	
	/**
	 * Pakuotės dydžių sąrašo išrinkimas
	 * @return type
	 */
	public function getPakuotesDydisList() {
		$query = "  SELECT *
					FROM `PakuotesDydis`";
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
	 * Asistentų sąrašo išrinkimas
	 * @return type
	 */
	public function getAsistentasList() {
		$query = "  SELECT *
					FROM `AptarnaujantisAsistentas`";
		$data = mysql::select($query);
		
		return $data;
	}
	/**
	 * Užsakymų sąrašo išrinkimas
	 * @return type
	 */
	public function getUzsakymasList() {
		$query = "  SELECT *
					FROM `Uzsakymas`";
		$data = mysql::select($query);
		
		return $data;
	}	
}