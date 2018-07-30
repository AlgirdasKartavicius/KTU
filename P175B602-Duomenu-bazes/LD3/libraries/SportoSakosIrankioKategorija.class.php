<?php

/**
 * Sporto šakų įrankių redagavimo klasė
 *
 * @author MK
 */

class SportoSakosIrankioKategorija {
	
	public function __construct() {
		
	}
	
	/**
	 * Sporto šakos įrankio išrinkimas
	 * @param type $id
	 * @return type
	 */
	public function getSportoSakosIrankioKategorija($id) {
		$query = "  SELECT *
					FROM `SportoSakosIrankioKategorija`
					WHERE `id`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0];
	}
	
	/**
	 * Sporto šakos įrankių sąrašo išrinkimas
	 * @param type $limit
	 * @param type $offset
	 * @return type
	 */
	public function getSportoSakosIrankioKategorijaList($limit = null, $offset = null) {
		$limitOffsetString = "";
		if(isset($limit)) {
			$limitOffsetString .= " LIMIT {$limit}";
		}
		if(isset($offset)) {
			$limitOffsetString .= " OFFSET {$offset}";
		}
		
		$query = "  SELECT `SportoSakosIrankioKategorija`.`id`,
						   `SportoSakosIrankioKategorija`.`pavadinimas`,
						    `SportoSaka`.`pavadinimas` AS `SportoSaka`
					FROM `SportoSakosIrankioKategorija`
						LEFT JOIN `SportoSaka`
							ON `SportoSakosIrankioKategorija`.`fk_SportoSakaid`=`SportoSaka`.`id` LIMIT {$limit} OFFSET {$offset}";
		$data = mysql::select($query);
		
		return $data;
	}

	/**
	 * Sporto šakos įrankių kiekio radimas
	 * @return type
	 */
	public function getSportoSakosIrankioKategorijaListCount() {
		$query = "  SELECT COUNT(`SportoSakosIrankioKategorija`.`id`) as `kiekis`
					FROM `SportoSakosIrankioKategorija`
						LEFT JOIN `SportoSaka`
							ON `SportoSakosIrankioKategorija`.`fk_SportoSakaid`=`SportoSaka`.`id`";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Sporto šakos įrankių išrinkimas pagal sporto šaką
	 * @param type $brandId
	 * @return type
	 */
	public function getSportoSakosIrankioKategorijaBySportoSaka($sportId) {
		$query = "  SELECT *
					FROM `SportoSakosIrankioKategorija`
					WHERE `fk_SportoSakaid`='{$sportId}'";
		$data = mysql::select($query);
		
		return $data;
	}
	
	/**
	 * Sporto šakos įrankio atnaujinimas
	 * @param type $data
	 */
	public function updateSportoSakosIrankioKategorija($data) {
		$query = "  UPDATE `SportoSakosIrankioKategorija`
					SET    `pavadinimas`='{$data['pavadinimas']}',
						   `fk_SportoSakaid`='{$data['fk_SportoSakaid']}'
					WHERE `id`='{$data['id']}'";
		mysql::query($query);
	}
	
	/**
	 * Sporto šakos įrankio įrašymas
	 * @param type $data
	 */
	public function insertSportoSakosIrankioKategorija($data) {
		$query = "  INSERT INTO `SportoSakosIrankioKategorija`
								(
									`id`,
									`pavadinimas`,
									`fk_SportoSakaid`
								)
								VALUES
								(
									'{$data['id']}',
									'{$data['pavadinimas']}',
									'{$data['fk_SportoSakaid']}'
								)";
		mysql::query($query);
	}
	
	/**
	 * Sporto šakos įrankio šalinimas
	 * @param type $id
	 */
	public function deleteSportoSakosIrankioKategorija($id) {
		$query = "  DELETE FROM `SportoSakosIrankioKategorija`
					WHERE `id`='{$id}'";
		mysql::query($query);
	}
	
	/**
	 * Nurodytos sporto šakos įrankio kategorijos prekių kiekio radimas
	 * @param type $id
	 * @return type
	 */
	public function getPrekeCountOfSportoSakosIrankioKategorija($id) {
		$query = "  SELECT COUNT(`Preke`.`kodas`) AS `kiekis`
					FROM `SportoSakosIrankioKategorija`
						INNER JOIN `Preke`
							ON `SportoSakosIrankioKategorija`.`id`=`Preke`.`fk_SportoSakosIrankioKategorijaid`
					WHERE `SportoSakosIrankioKategorija`.`id`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
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
	
	/**
	 * Paslaugos kainų įtraukimo į užsakymus kiekio radimas
	 * @param type $serviceId
	 * @param type $validFrom
	 * @return type
	 */
	public function getPricesCountOfOrderedServices($serviceId, $validFrom) {
		$query = "  SELECT COUNT(`SportoSakosIrankioKategorija`.`fk_SportoSakaid`) AS `kiekis`
					FROM `SportoSaka`
						INNER JOIN `SportoSakosIrankioKategorija`
							ON `SportoSaka`.`id`=`SportoSakosIrankioKategorija`.`fk_SportoSakaid`
					WHERE `SportoSaka`.`id`='{$serviceId}' AND `SportoSaka`.`id`='{$validFrom}'";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	public function getPrekeCountOfIrankis($id){
		$query = "	SELECT COUNT(1) AS `kiekis`
					FROM `Preke`
					WHERE `Preke`.`fk_SportoSakosIrankioKategorijaid` = '{$id}'";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
}