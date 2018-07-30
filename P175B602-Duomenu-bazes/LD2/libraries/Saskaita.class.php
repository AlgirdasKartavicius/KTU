<?php

/**
 * Sąskaitų redagavimo klasė
 *
 * @author MK
 */

class Saskaita {

	public function __construct() {
		
	}
	
	/**
	 * Sąskaitos išrinkimas
	 * @param type $id
	 * @return type
	 */
	public function getSaskaita($id) {
		$query = "  SELECT `Saskaita`.`nr`,
						   `Saskaita`.`data`,
						   `Saskaita`.`suma`,
						   `Saskaita`.`mokejimoData`,
						   `Saskaita`.`mokejimoBudas`,
						   `Saskaita`.`fk_Pirkejaskodas`,
						   `Saskaita`.`fk_AptarnaujantisAsistentastabelioNr`
					FROM `Saskaita`
					WHERE `Saskaita`.`nr`='{$id}'";
		$data = mysql::select($query);
		if (empty($data))
			return null;
		return $data[0];
	}
	
	/**
	 * Sąskaitos atnaujinimas
	 * @param type $data
	 */
	public function updateSaskaita($data) {
		$query = "  UPDATE `Saskaita`
					SET    `nr`='{$data['nr']}',
						   `data`='{$data['data']}',
						   `suma`='{$data['suma']}',
						   `mokejimoData`='{$data['mokejimoData']}',
						   `mokejimoBudas`='{$data['mokejimoBudas']}',
						   `fk_Pirkejaskodas`='{$data['fk_Pirkejaskodas']}',
						   `fk_AptarnaujantisAsistentastabelioNr`='{$data['fk_AptarnaujantisAsistentastabelioNr']}'
					WHERE `nr`='{$data['nr']}'";
		mysql::query($query);
	}

	/**
	 * Sąskaitos įrašymas
	 * @param type $data
	 */
	public function insertSaskaita($data) {
		$query = "  INSERT INTO `Saskaita` 
								(
									`nr`,
									`data`,
									`suma`,
									`mokejimoData`,
									`mokejimoBudas`,
									`fk_Pirkejaskodas`,
									`fk_AptarnaujantisAsistentastabelioNr`
								) 
								VALUES
								(
									'{$data['nr']}',
									'{$data['data']}',
									'{$data['suma']}',
									'{$data['mokejimoData']}',
									'{$data['mokejimoBudas']}',
									'{$data['fk_Pirkejaskodas']}',
									'{$data['fk_AptarnaujantisAsistentastabelioNr']}'
								)";
		mysql::query($query);
	}
	
	/** 
	 * Sąskaitų sąrašo išrinkimas
	 * @param type $limit
	 * @param type $offset
	 * @return type
	 */
	public function getSaskaitaList($limit = null, $offset = null) {
		$limitOffsetString = "";
		if(isset($limit)) {
			$limitOffsetString .= " LIMIT {$limit}";
		}
		if(isset($offset)) {
			$limitOffsetString .= " OFFSET {$offset}";
		}
		
		$query = "  SELECT `Saskaita`.`nr`,
						   `Saskaita`.`suma`,
						   `MokejimoBudas`.`name` AS `budas`,
						   `Pirkejas`.`kodas` AS `pirkejas`,
						   `AptarnaujantisAsistentas`.`tabelioNr` AS `aptarnaujantisAsistentas`
					FROM `Saskaita`
						LEFT JOIN `Pirkejas`
							ON `Saskaita`.`fk_Pirkejaskodas`=`Pirkejas`.`kodas`
						LEFT JOIN `AptarnaujantisAsistentas`
							ON `Saskaita`.`fk_AptarnaujantisAsistentastabelioNr`=`AptarnaujantisAsistentas`.`tabelioNr` 
						LEFT JOIN `MokejimoBudas`
							ON `Saskaita`.`mokejimoBudas`=`MokejimoBudas`.`id` " . $limitOffsetString;
		$data = mysql::select($query);
		
		return $data;
	}

	/** 
	 * Sąskaitų kiekio radimas
	 * @return type
	 */
	public function getSaskaitaListCount() {
		$query = "  SELECT COUNT(`nr`) as `kiekis`
					FROM `Saskaita`";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Sąskaitos šalinimas
	 * @param type $id
	 */
	public function deleteSaskaita($id) {
		$query = "  DELETE FROM `Saskaita`
					WHERE `nr`='{$id}'";
		mysql::query($query);
	}
	
	/**
	 * Prekės būsenų sąrašo išrinkimas
	 * @return type
	 */
	public function getMokejimoBudasList() {
		$query = "  SELECT *
					FROM `MokejimoBudas`";
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
	 * Prekės būsenų sąrašo išrinkimas
	 * @return type
	 */
	public function getAsistentasList() {
		$query = "  SELECT *
					FROM `AptarnaujantisAsistentas`";
		$data = mysql::select($query);
		
		return $data;
	}
}