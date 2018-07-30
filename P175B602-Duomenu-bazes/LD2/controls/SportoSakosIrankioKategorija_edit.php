<?php

	include 'libraries/SportoSaka.class.php';
	$sportoSakaObj = new SportoSaka();

	include 'libraries/SportoSakosIrankioKategorija.class.php';
	$sportoSakosIrankioKategorijaObj = new SportoSakosIrankioKategorija();
	
	$formErrors = null;
	$fields = array();
	
	// nustatome privalomus laukus
	$required = array('pavadinimas', 'fk_SportoSakaid');

	// maksimalūs leidžiami laukų ilgiai
	$maxLengths = array (
		'pavadinimas' => 20
	);
	
	// paspaustas išsaugojimo mygtukas
	if(!empty($_POST['submit'])) {
		// nustatome laukų validatorių tipus
		$validations = array (
			'pavadinimas' => 'alfanum',
			'fk_SportoSakaid' => 'positivenumber');
		
		// sukuriame validatoriaus objektą
		include 'utils/validator.class.php';
		$validator = new validator($validations, $required, $maxLengths);
		
		// laukai įvesti be klaidų
		if($validator->validate($_POST)) {
			// suformuojame laukų reikšmių masyvą SQL užklausai
			$data = $validator->preparePostFieldsForSQL();
			if(isset($data['id'])) {
				// atnaujiname duomenis
				$sportoSakosIrankioKategorijaObj->updateSportoSakosIrankioKategorija($data);
			} else {
				// randame didžiausią sporto šakos įrankių kategorijos id duomenų bazėje
				$latestId = $sportoSakosIrankioKategorijaObj->getMaxIdOfSportoSakosIrankioKategorija();

				// įrašome naują įrašą
				$data['id'] = $latestId + 1;
				$sportoSakosIrankioKategorijaObj->insertSportoSakosIrankioKategorija($data);
			}
			
			// nukreipiame į sporto šakos įrankių kategorijos puslapį
			header("Location: index.php?module={$module}");
			die();
		} else {
			// gauname klaidų pranešimą
			$formErrors = $validator->getErrorHTML();
			// gauname įvestus laukus
			$fields = $_POST;
		}
	} else {
		// tikriname, ar nurodytas elemento id. Jeigu taip, išrenkame elemento duomenis ir jais užpildome formos laukus.
		if(!empty($id)) {
			$fields = $sportoSakosIrankioKategorijaObj->getSportoSakosIrankioKategorija($id);
		}
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li><a href="index.php?module=<?php echo $module; ?>">Sporto šakos įrankių kategorijos</a></li>
	<li><?php if(!empty($id)) echo "Kategorijos redagavimas"; else echo "Nauja kategorija"; ?></li>
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
			<legend>Kategorijos informacija</legend>
			<p>
				<label class="field" for="SportoSaka">Sporto šaka<?php echo in_array('fk_SportoSakaid', $required) ? '<span> *</span>' : ''; ?></label>
				<select id="SportoSaka" name="fk_SportoSakaid">
					<option value="-1">Pasirinkite sporto šaką</option>
					<?php
						// išrenkame visas sporto šakas
						$sportoSakos = $sportoSakaObj->getSportoSakaList();
						foreach($sportoSakos as $key => $val) {
							$selected = "";
							if(isset($fields['fk_SportoSakaid']) && $fields['fk_SportoSakaid'] == $val['id']) {
								$selected = " selected='selected'";
							}
							echo "<option{$selected} value='{$val['id']}'>{$val['pavadinimas']}</option>";
						}
					?>
				</select>
			</p>
			<p>
				<label class="field" for="name">Pavadinimas<?php echo in_array('pavadinimas', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="name" name="pavadinimas" class="textbox-150" value="<?php echo isset($fields['pavadinimas']) ? $fields['pavadinimas'] : ''; ?>">
				<?php if(key_exists('pavadinimas', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['pavadinimas']} simb.)</span>"; ?>
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