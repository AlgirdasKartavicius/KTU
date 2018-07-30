<?php

	include 'libraries/SportoSaka.class.php';
	$sportoSakaObj = new SportoSaka();
	
	include 'libraries/SportoSakosIrankioKategorija.class.php';
	$kategorijaObj = new SportoSakosIrankioKategorija();
	
	$formErrors = null;
	$fields = array();
	
	// nustatome privalomus laukus
	$required = array('pavadinimas', 'kilmesSalis', 'kategorija');
	
	// maksimalūs leidžiami laukų ilgiai
	$maxLengths = array (
		'pavadinimas' => 20,
		'kilmesSalis' => 20
	);
	
	// paspaustas išsaugojimo mygtukas
	if(!empty($_POST['submit'])) {
		// nustatome laukų validatorių tipus
		$validations = array (
			'pavadinimas' => 'alfanum',
			'kilmesSalis' => 'words',
			'kategorija' => 'anything');
		
		// sukuriame validatoriaus objektą
		include 'utils/validator.class.php';
		$validator = new validator($validations, $required, $maxLengths);

		if($validator->validate($_POST)) {
			// suformuojame laukų reikšmių masyvą SQL užklausai
			$data = $validator->preparePostFieldsForSQL();
			if(isset($data['id'])) {
				// atnaujiname duomenis
				$sportoSakaObj->updateSportoSaka($data);
				$deleteQueryClause = "";
				if(isset($data['kategorija'])) {
					foreach($data['kategorija'] as $key=>$val) {
						if($data['neaktyvus'][$key] == 1) {
							$deleteQueryClause .= " AND NOT `SportoSakosIrankioKategorija`.`id`='" . $data['idk'][$key] . "'";
						}
					}
					$sportoSakaObj->deleteSportoSakosIrankioKategorija($data['id'], $deleteQueryClause);
					// atnaujiname kategorijas, kurios nėra naudojamos sporto šakose
					$sportoSakaObj->insertSportoSakosIrankioKategorija($data);
				}
				else{
					$sportoSakaObj->deleteSportoSakosIrankioKategorija($data['id'], $deleteQueryClause);
					// atnaujiname kategorijas, kurios nėra naudojamos sporto šakose
					$sportoSakaObj->insertSportoSakosIrankioKategorija($data);
				}
			} else {
				// randame didžiausią sporto šakos id duomenų bazėje
				$latestId = $sportoSakaObj->getMaxIdOfSportoSaka();
				
				// įrašome naują įrašą
				$data['id'] = $latestId + 1;
				$sportoSakaObj->insertSportoSaka($data);
				
				// įrašome sporto šakos įrankio kategorijas
				$sportoSakaObj->insertSportoSakosIrankioKategorija($data);
			}
			
			// nukreipiame į sporto šakos puslapį
			header("Location: index.php?module={$module}");
			die();
		} else {
			// gauname klaidų pranešimą
			$formErrors = $validator->getErrorHTML();
			// gauname įvestus laukus
			$fields = $_POST;
			if(isset($_POST['kategorija']) && sizeof($_POST['kategorija']) > 0) {
				$i = 0;
				foreach($_POST['kategorija'] as $key => $val) {
					$fields['kategorijos'][$i]['pavadinimas'] = $val;
					$fields['kategorijos'][$i]['id'] = $_POST['idk'][$key];
					$fields['kategorijos'][$i]['neaktyvus'] = $_POST['neaktyvus'][$key];
					$i++;
				}
			}
		}
	} else {
		// tikriname, ar nurodytas elemento id. Jeigu taip, išrenkame elemento duomenis ir jais užpildome formos laukus.
		if(!empty($id)) {
			$fields = $sportoSakaObj->getSportoSaka($id);
			$tmp = $sportoSakaObj->getSportoSakosIrankioKategorija($id);
			if(sizeof($tmp)) {
				foreach($tmp as $key => $val) {
					// jeigu kategorija yra naudojama, jos koreguoti neleidziame ir įvedimo laukelį padarome neaktyvų
					$count = $kategorijaObj->getPrekeCountOfIrankis($val['id']);
					if($count > 0) {
						$val['neaktyvus'] = 1;
					}
					$fields['kategorijos'][] = $val;
				}
			}
		}
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li><a href="index.php?module=<?php echo $module; ?>">Sporto šakos</a></li>
	<li><?php if(!empty($id)) echo "Sporto šakos redagavimas"; else echo "Nauja sporto šaka"; ?></li>
</ul>
<div class="float-clear"></div>
<div id="formContainer">
	<?php if($formErrors != null) { ?>
		<div class="errorBox">
			Neįvesti arba neteisingai įvesti šie laukai:
			<?php 
				echo $formErrors;
			?>
		</div>
	<?php } ?>
	<form action="" method="post">
		<fieldset>
			<legend>Sporto šakos informacija</legend>
			<p>
				<label class="field" for="pavadinimas">Pavadinimas<?php echo in_array('pavadinimas', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="pavadinimas" name="pavadinimas" class="textbox-150" value="<?php echo isset($fields['pavadinimas']) ? $fields['pavadinimas'] : ''; ?>">
				<?php if(key_exists('pavadinimas', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['pavadinimas']} simb.)</span>"; ?>
			</p>
			<p>
				<label class="field" for="kilmesSalis">Kilmės šalis<?php echo in_array('kilmesSalis', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="kilmesSalis" name="kilmesSalis" class="textbox-150" value="<?php echo isset($fields['kilmesSalis']) ? $fields['kilmesSalis'] : ''; ?>">
				<?php if(key_exists('kilmesSalis', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['kilmesSalis']} simb.)</span>"; ?>
			</p>
		</fieldset>
		<fieldset>
			<legend>Kategorijos informacija</legend>
			<div class="childRowContainer">
				<div class="labelLeft<?php if(empty($fields['kategorijos']) || sizeof($fields['kategorijos']) == 0) echo ' hidden'; ?>">Pavadinimas</div>
				<div class="float-clear"></div>
				<?php
					if(empty($fields['kategorijos']) || sizeof($fields['kategorijos']) == 0) {
				?>
					
					<div class="childRow hidden">
						<input type="text" name="kategorija[]" value="" class="textbox-70" disabled="disabled" />
						<input type="hidden" class="isDisabledForEditing" name="idk[]" value="" />
						<input type="hidden" class="isDisabledForEditing" name="neaktyvus[]" value="0" />
						<a href="#" title="" class="removeChild">šalinti</a>
					</div>
					<div class="float-clear"></div>
					
				<?php
					} else {
						foreach($fields['kategorijos'] as $key => $val) {
				?>
							<div class="childRow">
								<input type="text" name="kategorija[]" value="<?php echo $val['pavadinimas']; ?>" class="textbox-70<?php if(isset($val['neaktyvus']) && $val['neaktyvus'] == 1) echo ' disabledInput'; ?>" />
								<input type="hidden" class="isDisabledForEditing" name="idk[]" value="<?php echo $val['id']; ?>" />
								<input type="hidden" class="isDisabledForEditing" name="neaktyvus[]" value="<?php if(isset($val['neaktyvus']) && $val['neaktyvus'] == 1) echo "1"; else echo "0"; ?>" />
								<a href="#" title="" class="removeChild<?php if(isset($val['neaktyvus']) && $val['neaktyvus'] == 1) echo " hidden"; ?>">šalinti</a>
							</div>
							<div class="float-clear"></div>
				<?php 
						}
					}
				?>
			</div>
			<p id="newItemButtonContainer">
				<a href="#" title="" class="addChild">Pridėti</a>
			</p>
		</fieldset>
		<p class="required-note">* pažymėtus laukus užpildyti privaloma</p>
		<p>
			<input type="submit" class="submit" name="submit" value="Išsaugoti">
		</p>
		<?php if(isset($fields['id'])) { ?>
			<input type="hidden" name="id" value="<?php echo $fields['id']; ?>" />
		<?php } ?>
	</form>
</div>