<?php

	include 'libraries/Preke.class.php';
	$prekeObj = new Preke();

	include 'libraries/SportoSakosIrankioKategorija.class.php';
	$sportoSakosIrankioKategorijaObj = new SportoSakosIrankioKategorija();

	include 'libraries/SportoSaka.class.php';
	$sportoSakaObj = new SportoSaka();
	
	$formErrors = null;
	$fields = array();

	// nustatome privalomus laukus
	$required = array('fk_SportoSakosIrankioKategorijaid', 'kodas', 'pavadinimas', 'kaina', 'busena', 'sezonas', 'spalva');
	
	// maksimalūs leidžiami laukų ilgiai
	$maxLengths = array (
		'kodas' => 6
	);
	
	// vartotojas paspaudė išsaugojimo mygtuką
	if(!empty($_POST['submit'])) {
		// sukuriame laukų validatoriaus objektą
		include 'utils/validator.class.php';
		// nustatome laukų validatorių tipus
		$validations = array (
			'fk_SportoSakosIrankioKategorijaid' => 'positivenumber',
			'kodas' => 'alfanum',
			'pavadinimas' => 'alfanum',
			'kaina' => 'price',
			'aprasymas' => 'anything',
			'pagaminimoData' => 'date',
			'garantija' => 'float',
			'kilmesSalis' => 'words',
			'busena' => 'positivenumber',
			'sezonas' => 'positivenumber',
			'spalva' => 'positivenumber',
			);
				
		$validator = new validator($validations, $required, $maxLengths);

		// laukai įvesti be klaidų
		if($validator->validate($_POST)) {
			// suformuojame laukų reikšmių masyvą SQL užklausai
			$data = $validator->preparePostFieldsForSQL();
			
			if(isset($data['editing'])) {
				// atnaujiname duomenis
				$prekeObj->updatePreke($data);
			} else {
				$tmp = $prekeObj->getPreke($data['kodas']);
				
				if(isset($tmp['kodas'])){
					// sudarome klaidų pranešimą
					$formErrors = "Prekė su įvestu kodu jau egzistuoja.";
					// laukų reikšmių kintamajam priskiriame įvestų laukų reikšmes
					$fields = $_POST;
				} else{
				
				// įrašome naują prekę
					$prekeObj->insertPreke($data);
				}
				
			}
			if($formErrors == null) {
				// nukreipiame vartotoją į prekių puslapį
				header("Location: index.php?module={$module}");
				die();
			}
		} else {
			// gauname klaidų pranešimą
			$formErrors = $validator->getErrorHTML();
			// laukų reikšmių kintamajam priskiriame įvestų laukų reikšmes
			$fields = $_POST;
		}
	} else {
		// tikriname, ar nurodytas elemento id. Jeigu taip, išrenkame elemento duomenis ir jais užpildome formos laukus.
		if(!empty($id)) {
			// išrenkame prekę
			$fields = $prekeObj->getPreke($id);
			$fields['editing'] = 1;
		}
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li><a href="index.php?module=<?php echo $module; ?>">Prekės</a></li>
	<li><?php if(!empty($id)) echo "Prekės redagavimas"; else echo "Nauja prekė"; ?></li>
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
			<legend>Prekės informacija</legend>
			<p>
				<label class="field" for="fk_SportoSakosIrankioKategorijaid">Kategorija<?php echo in_array('fk_SportoSakosIrankioKategorijaid', $required) ? '<span> *</span>' : ''; ?></label>
				<select id="fk_SportoSakosIrankioKategorijaid" name="fk_SportoSakosIrankioKategorijaid">
					<option value="-1">---------------</option>
					<?php
						// išrenkame visas kategorijas sugeneruoti pasirinkimų lauką
						$sportoSakos = $sportoSakaObj->getSportoSakaList();
						foreach($sportoSakos as $key => $val) {
							echo "<optgroup label='{$val['pavadinimas']}'>";

							$kategorija = $sportoSakosIrankioKategorijaObj->getSportoSakosIrankioKategorijaBySportoSaka($val['id']);
							foreach($kategorija as $key2 => $val2) {
								$selected = "";
								if(isset($fields['fk_SportoSakosIrankioKategorijaid']) && $fields['fk_SportoSakosIrankioKategorijaid'] == $val2['id']) {
									$selected = " selected='selected'";
								}
								echo "<option{$selected} value='{$val2['id']}'>{$val2['pavadinimas']}</option>";
							}
						}
					?>
				</select>
			</p>
			<p>
				<label class="field" for="kodas">Kodas<?php echo in_array('kodas', $required) ? '<span> *</span>' : ''; ?></label>
					<?php if(!isset($fields['editing'])) { ?>
						<input type="text" id="kodas" name="kodas" class="textbox-150" value="<?php echo isset($fields['kodas']) ? $fields['kodas'] : ''; ?>" />
						<?php if(key_exists('kodas', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['kodas']} simb.)</span>"; ?>
					<?php } else { ?>
						<span class="input-value"><?php echo $fields['kodas']; ?></span>
						<input type="hidden" name="editing" value="1" />
						<input type="hidden" name="kodas" value="<?php echo $fields['kodas']; ?>" />
					<?php } ?>
			</p>
			<p>
				<label class="field" for="pavadinimas">Pavadinimas<?php echo in_array('pavadinimas', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="pavadinimas" name="pavadinimas" class="textbox-70" value="<?php echo isset($fields['pavadinimas']) ? $fields['pavadinimas'] : ''; ?>">
				<?php if(key_exists('pavadinimas', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['pavadinimas']} simb.)</span>"; ?>
			</p>
			<p>
				<label class="field" for="kaina">Kaina<?php echo in_array('kaina', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="kaina" name="kaina" class="textbox-70" value="<?php echo isset($fields['kaina']) ? $fields['kaina'] : ''; ?>">
				<?php if(key_exists('kaina', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['kaina']} simb.)</span>"; ?>
			</p>
			<p>
				<label class="field" for="aprasymas">Aprašymas<?php echo in_array('aprasymas', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="aprasymas" name="aprasymas" class="textbox-70" value="<?php echo isset($fields['aprasymas']) ? $fields['aprasymas'] : ''; ?>">
				<?php if(key_exists('aprasymas', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['aprasymas']} simb.)</span>"; ?>
			</p>
			<p>
				<label class="field" for="pagaminimoData">Pagaminimo data<?php echo in_array('pagaminimoData', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="pagaminimoData" name="pagaminimoData" class="date textbox-70" value="<?php echo isset($fields['pagaminimoData']) ? $fields['pagaminimoData'] : ''; ?>">
				<?php if(key_exists('pagaminimoData', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['pagaminimoData']} simb.)</span>"; ?>
			</p>
			<p>
				<label class="field" for="garantija">Garantija<?php echo in_array('garantija', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="garantija" name="garantija" class="textbox-70" value="<?php echo isset($fields['garantija']) ? $fields['garantija'] : ''; ?>">
				<?php if(key_exists('garantija', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['garantija']} simb.)</span>"; ?>
			</p>
			<p>
				<label class="field" for="kilmesSalis">Kilmės šalis<?php echo in_array('kilmesSalis', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="kilmesSalis" name="kilmesSalis" class="textbox-70" value="<?php echo isset($fields['kilmesSalis']) ? $fields['kilmesSalis'] : ''; ?>">
				<?php if(key_exists('kilmesSalis', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['kilmesSalis']} simb.)</span>"; ?>
			</p>
			<p>
				<label class="field" for="busena">Būsena<?php echo in_array('busena', $required) ? '<span> *</span>' : ''; ?></label>
				<select id="busena" name="busena">
					<option value="-1">---------------</option>
					<?php
						// išrenkame visas kategorijas sugeneruoti pasirinkimų lauką
						$gearboxes = $prekeObj->getPrekeBusenaList();
						foreach($gearboxes as $key => $val) {
							$selected = "";
							if(isset($fields['busena']) && $fields['busena'] == $val['id']) {
								$selected = " selected='selected'";
							}
							echo "<option{$selected} value='{$val['id']}'>{$val['name']}</option>";
						}
					?>
				</select>
			</p>
			<p>
				<label class="field" for="sezonas">Sezonas<?php echo in_array('sezonas', $required) ? '<span> *</span>' : ''; ?></label>
				<select id="sezonas" name="sezonas">
					<option value="-1">---------------</option>
					<?php
						// išrenkame visas kategorijas sugeneruoti pasirinkimų lauką
						$fueltypes = $prekeObj->getSezonasList();
						foreach($fueltypes as $key => $val) {
							$selected = "";
							if(isset($fields['sezonas']) && $fields['sezonas'] == $val['id']) {
								$selected = " selected='selected'";
							}
							echo "<option{$selected} value='{$val['id']}'>{$val['name']}</option>";
						}
					?>
				</select>
			</p>
			<p>
				<label class="field" for="spalva">Spalva<?php echo in_array('spalva', $required) ? '<span> *</span>' : ''; ?></label>
				<select id="spalva" name="spalva">
					<option value="-1">---------------</option>
					<?php
						// išrenkame visas kategorijas sugeneruoti pasirinkimų lauką
						$bodytypes = $prekeObj->getSpalvaList();
						foreach($bodytypes as $key => $val) {
							$selected = "";
							if(isset($fields['spalva']) && $fields['spalva'] == $val['id']) {
								$selected = " selected='selected'";
							}
							echo "<option{$selected} value='{$val['id']}'>{$val['name']}</option>";
						}
					?>
				</select>
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