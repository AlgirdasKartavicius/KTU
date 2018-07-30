<?php

/**
 * Prėkės būsenos redagavimo klasė
 *
 * @author MK
 */



class SportoSaka {
	
	public function __construct() {
		
	}
	
	/**
	 * Būsenos išrinkimas
	 * @param type $id
	 * @return type
	 */
	public function getSportoSaka($id) {
		$query = "  SELECT *
					FROM `SportoSaka`
					WHERE `id`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0];
	}
	
	/**
	 * Būsenų sąrašo išrinkimas
	 * @param type $limit
	 * @param type $offset
	 * @return type
	 */
	public function getSportoSakaList($limit = null, $offset = null) {
		$limitOffsetString = "";
		if(isset($limit)) {
			$limitOffsetString .= " LIMIT {$limit}";
		}
		if(isset($offset)) {
			$limitOffsetString .= " OFFSET {$offset}";
		}
		
		$query = "  SELECT *
					FROM `SportoSaka`" . $limitOffsetString;
		$data = mysql::select($query);
		
		return $data;
	}

	/**
	 * Būsenų kiekio radimas
	 * @return type
	 */
	public function getSportoSakaListCount() {
		$query = "  SELECT COUNT(`id`) as `kiekis`
					FROM `SportoSaka`";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Būsenos įrašymas
	 * @param type $data
	 */
	public function insertSportoSaka($data) {
		$query = "  INSERT INTO `SportoSaka`
								(
									`id`,
									`pavadinimas`,
									`kilmesSalis`
								)
								VALUES
								(
									'{$data['id']}',
									'{$data['pavadinimas']}',
									'{$data['kilmesSalis']}'
								)";
		mysql::query($query);
	}
	
	/**
	 * Būsenos atnaujinimas
	 * @param type $data
	 */
	public function updateSportoSaka($data) {
		$query = "  UPDATE `SportoSaka`
					SET    `pavadinimas`='{$data['pavadinimas']}',
						   `kilmesSalis`='{$data['kilmesSalis']}'
					WHERE `id`='{$data['id']}'";
		mysql::query($query);
	}
	
	/**
	 * Būsenos šalinimas
	 * @param type $id
	 */
	public function deleteSportoSaka($id) {
		$query = "  DELETE FROM `SportoSaka`
					WHERE `id`='{$id}'";
		mysql::query($query);
	}
	
	/**
	 * Būsenos kiekio radimas
	 * @param type $id
	 * @return type*/
	 
	public function getModelCountOfSportoSaka($id) {
		$query = "  SELECT COUNT(`SportoSaka`.`id`) AS `kiekis`
					FROM `SportoSaka`
						INNER JOIN `SportoSakosIrankioKategorija`
							ON `SportoSaka`.`id`=`SportoSakosIrankioKategorija`.`fk_SportoSakaid`
					WHERE `SportoSaka`.`id`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Didžiausiausios būsenos id reikšmės radimas
	 * @return type
	 */
	public function getMaxIdOfSportoSaka() {
		$query = "  SELECT MAX(`id`) AS `latestId`
					FROM `SportoSaka`";
		$data = mysql::select($query);
		
		return $data[0]['latestId'];
	}
	
	/**
	 * Sporto šakos įrankių sąrašo radimas
	 * @param type $sportasId
	 * @return type
	 */
	public function getSportoSakosIrankioKategorija($sportasId) {
		$query = "  SELECT *
					FROM `SportoSakosIrankioKategorija`
					WHERE `fk_SportoSakaid`='{$sportasId}'";
		$data = mysql::select($query);
		
		return $data;
	}
	
	/**
	 * Didžiausio sporto šakos įrankio id reikšmės radimas
	 * @return type
	 */
	public function getMaxIdOfSportoSakosIrankioKategorija() {
		$query = "  SELECT MAX(`id`) AS `latestId`
					FROM `SportoSakosIrankioKategorija`";
		$data = mysql::select($query);
		
		return $data[0]['latestId'];
	}
	
	public function exists($val, $data){
		$query = "	SELECT COUNT(1) as `kiekis`
					FROM `SportoSakosIrankioKategorija`
					WHERE `SportoSakosIrankioKategorija`.`pavadinimas`= '{$val}' 
						AND `SportoSakosIrankioKategorija`.`fk_SportoSakaid` = '{$data['id']}'";
		$data = mysql::select($query);
		return $data[0]['kiekis'];
	}
	
	/**
	 * Sporto šakos įrankių kategorijų įrašymas
	 * @param type $data
	 */
	public function insertSportoSakosIrankioKategorija($data) {
		if(isset($data['kategorija'])) {
			foreach($data['kategorija'] as $key=>$val) {
				if($data['neaktyvus'] == array() || $data['neaktyvus'][$key] == 0) {
					$kiekis = $this->exists($val, $data);
					if ($kiekis == 0){
						$latestId = $this->getMaxIdOfSportoSakosIrankioKategorija();
						$data['idk'][$key] = $latestId + 1;
						$query = "  INSERT INTO `SportoSakosIrankioKategorija`
												(
													`pavadinimas`,
													`fk_SportoSakaid`,
													`id`
												)
												VALUES
												(
													'{$val}',
													'{$data['id']}',
													'{$data['idk'][$key]}'
												)";
						mysql::query($query);
					}
				}
			}
		}
	}
	
	/**
	 * Sporto šakos įrankių šalinimas
	 * @param type $sportasId
	 * @param type $clause
	 */
	public function deleteSportoSakosIrankioKategorija($sportasId, $clause = "") {
		$query = "  DELETE FROM `SportoSakosIrankioKategorija`
					WHERE `fk_SportoSakaid`='{$sportasId}'" . $clause;
		mysql::query($query);
	}
}