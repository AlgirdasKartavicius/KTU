<?php

/**
 * Prekių redagavimo klasė
 *
 * @author MK
 */

class Preke {

	public function __construct() {
		
	}
	
	/**
	 * Prekės išrinkimas
	 * @param type $id
	 * @return type
	 */
	public function getPreke($id) {
		$query = "  SELECT `Preke`.`kodas`,
						   `Preke`.`pavadinimas`,
						   `Preke`.`kaina`,
						   `Preke`.`aprasymas`,
						   `Preke`.`pagaminimoData`,
						   `Preke`.`garantija`,
						   `Preke`.`kilmesSalis`,
						   `Preke`.`busena`,
						   `Preke`.`sezonas`,
						   `Preke`.`spalva`,
						   `Preke`.`fk_SportoSakosIrankioKategorijaid`
					FROM `Preke`
					WHERE `Preke`.`kodas`='{$id}'";
		$data = mysql::select($query);
		if (empty($data))
			return null;
		return $data[0];
	}
	
	/**
	 * Prekės atnaujinimas
	 * @param type $data
	 */
	public function updatePreke($data) {
		$query = "  UPDATE `Preke`
					SET    `pavadinimas`='{$data['pavadinimas']}',
						   `kaina`='{$data['kaina']}',
						   `aprasymas`='{$data['aprasymas']}',
						   `pagaminimoData`='{$data['pagaminimoData']}',
						   `garantija`='{$data['garantija']}',
						   `kilmesSalis`='{$data['kilmesSalis']}',
						   `busena`='{$data['busena']}',
						   `sezonas`='{$data['sezonas']}',
						   `spalva`='{$data['spalva']}',
						   `fk_SportoSakosIrankioKategorijaid`='{$data['fk_SportoSakosIrankioKategorijaid']}'
					WHERE `kodas`='{$data['kodas']}'";
		mysql::query($query);
	}

	/**
	 * Prekės įrašymas
	 * @param type $data
	 */
	public function insertPreke($data) {
		$query = "  INSERT INTO `Preke` 
								(
									`kodas`,
									`pavadinimas`,
									`kaina`,
									`aprasymas`,
									`pagaminimoData`,
									`garantija`,
									`kilmesSalis`,
									`busena`,
									`sezonas`,
									`spalva`,
									`fk_SportoSakosIrankioKategorijaid`
								) 
								VALUES
								(
									'{$data['kodas']}',
									'{$data['pavadinimas']}',
									'{$data['kaina']}',
									'{$data['aprasymas']}',
									'{$data['pagaminimoData']}',
									'{$data['garantija']}',
									'{$data['kilmesSalis']}',
									'{$data['busena']}',
									'{$data['sezonas']}',
									'{$data['spalva']}',
									'{$data['fk_SportoSakosIrankioKategorijaid']}'
								)";
		mysql::query($query);
	}
	
	/** 
	 * Prekių sąrašo išrinkimas
	 * @param type $limit
	 * @param type $offset
	 * @return type
	 */
	public function getPrekeList($limit = null, $offset = null) {
		$limitOffsetString = "";
		if(isset($limit)) {
			$limitOffsetString .= " LIMIT {$limit}";
		}
		if(isset($offset)) {
			$limitOffsetString .= " OFFSET {$offset}";
		}
		
		$query = "  SELECT `Preke`.`kodas`,
						   `Preke`.`pavadinimas`,
						   `Preke`.`kaina`,
						   `SportoSakosIrankioKategorija`.`pavadinimas` AS `sportoSakosIrankioKategorija`,
						   `SportoSaka`.`pavadinimas` AS `sportoSaka`,
						   `Busena`.`name` AS `busena`
					FROM `Preke`
						LEFT JOIN `SportoSakosIrankioKategorija`
							ON `Preke`.`fk_SportoSakosIrankioKategorijaid`=`SportoSakosIrankioKategorija`.`id`
						LEFT JOIN `SportoSaka`
							ON `SportoSakosIrankioKategorija`.`fk_SportoSakaid`=`SportoSaka`.`id`
						LEFT JOIN `Busena`
							ON `Preke`.`busena`=`Busena`.`id`" . $limitOffsetString;
		$data = mysql::select($query);
		
		return $data;
	}

	/** 
	 * Prekių kiekio radimas
	 * @return type
	 */
	public function getPrekeListCount() {
		$query = "  SELECT COUNT(`Preke`.`kodas`) AS `kiekis`
					FROM `Preke`
						LEFT JOIN `SportoSakosIrankioKategorija`
							ON `Preke`.`fk_SportoSakosIrankioKategorijaid`=`SportoSakosIrankioKategorija`.`id`
						LEFT JOIN `SportoSaka` 
							ON `SportoSakosIrankioKategorija`.`fk_SportoSakaid`=`SportoSaka`.`id`";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
	
	/**
	 * Prekės šalinimas
	 * @param type $id
	 */
	public function deletePreke($id) {
		$query = "  DELETE FROM `Preke`
					WHERE `kodas`='{$id}'";
		mysql::query($query);
	}
	
	/** 
	 * Sutačių, į kurias įtrauktas automobilis, kiekio radimas
	 * @param type $id
	 * @return type
	 */
	public function getUzsakymoPrekeCountOfPreke($id) {
		$query = "  SELECT COUNT(`UzsakymoPreke`.`fk_UzsakymasuzsakymoNumeris`) AS `kiekis`
					FROM `Preke`
						INNER JOIN `UzsakymoPreke`
							ON `Preke`.`kodas`=`UzsakymoPreke`.`fk_Prekekodas`
					WHERE `Preke`.`kodas`='{$id}'";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}

	/**
	 * Spalvų sąrašo išrinkimas
	 * @return type
	 */
	public function getSpalvaList() {
		$query = "  SELECT *
					FROM `Spalva`";
		$data = mysql::select($query);
		
		return $data;
	}

	/**
	 * Sezonų sąrašo išrinkimas
	 * @return type
	 */
	public function getSezonasList() {
		$query = "  SELECT *
					FROM `Sezonas`";
		$data = mysql::select($query);
		
		return $data;
	}

	/**
	 * Prekės būsenų sąrašo išrinkimas
	 * @return type
	 */
	public function getPrekeBusenaList() {
		$query = "  SELECT *
					FROM `Busena`";
		$data = mysql::select($query);
		
		return $data;
	}
	
	public function getPricesCountOfOrderedServices($serviceId, $validFrom) {
		$query = "  SELECT COUNT(`UzsakymoPreke`.`fk_Prekekodas`) AS `kiekis`
					FROM `Uzsakymas`
						INNER JOIN `UzsakymoPreke`
							ON `Uzsakymas`.`uzsakymoNumeris`=`UzsakymoPreke`.`fk_UzsakymasuzsakymoNumeris`
					WHERE `Uzsakymas`.`uzsakymoNumeris`='{$serviceId}' AND `Uzsakymas`.`uzsakymoNumeris`='{$validFrom}'";
		$data = mysql::select($query);
		
		return $data[0]['kiekis'];
	}
}