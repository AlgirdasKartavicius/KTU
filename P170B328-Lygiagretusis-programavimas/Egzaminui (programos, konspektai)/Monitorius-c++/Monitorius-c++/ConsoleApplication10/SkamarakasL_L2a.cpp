#include <iostream>
#include <fstream>
#include <algorithm>
#include <iomanip>
#include <cmath>
#include <string>
#include <thread>
#include <future>
#include <chrono>
using namespace std;

/**
*	Duomenu failo vardas
*/
const char duomenuFailas[] = "SkamarakasL_L2a_3.txt";

/**
*	Rezultatu failo vardas
*/
const char rezultatuFailas[] = "SkamarakasL_L2a_rez.txt";

/**
*	Maksimalus studentu skaicius masyve
*/
const int maksimalusStudentuSkaiciusFakultete = 100;

/**
*	Maksimalus fakultetu skaicius
*/
const int maksimalusFakultetuSkaicius = 100;

/**
*	Maksimalus elementu skaicius bendram giju masyve
*/
const int maksimalusGijuElementuSkaicius = 1000;

/**
*	Realus elementu skaicius bendram giju masyve
*/
int ElementuSkaiciusBendramGijuMasyve = 0;

/**
*	Globalus kintamasis nurodantis duomenu rasymo giju darbo pabaiga
*/
bool RasymasBaigesi = false;

/**
*	Monitorius saugantis priejima prie kritines sekcijos
*/
mutex Monitor;

/**
*	Studento klasë
*/
class Studentas
{
	/**
	*	Studento vardas
	*
	*	@param string
	*/
	string vardas;

	/**
	*	Studento kursas
	*
	*	@param int
	*/
	int kursas;

	/**
	*	Studento vidurkis
	*
	*	@param double
	*/
	double vidurkis;

public:

	/**
	*	Klases konstruktorius
	*/
	Studentas(string vardas, int kursas, double vidurkis): vardas(vardas), kursas(kursas), vidurkis(vidurkis)
	{}

	/**
	*	Klases konstruktorius
	*/
	Studentas(): vardas(""), kursas(0), vidurkis(0.0)
	{}

	/**
	*	Metodas iðvedantis studento vardà
	*
	*	@return string
	*/
	string iðvestiStudentoVarda()
	{
		return  this->vardas;
	}

	/**
	*	Metodas iðvedantis studento kursà
	*
	*	@return int
	*/
	int iðvestiStudentoKursa()
	{
		return  this->kursas;
	}

	/**
	*	Metodas iðvedantis studento vidurki
	*
	*	@return double
	*/
	double iðvestiStudentoVidurki()
	{
		return  this->vidurkis;
	}

	/**
	*	Uþklotas operatorius >
	* 
	*	@param Studentas stud
	*
	*	@return Studentas
	*/
	bool Studentas::operator > (const Studentas & kitas) 
	{
		return vardas > kitas.vardas;
	}

};

	/**
	*	Fakulteto klase
	*/
class Fakultetas
{
	/**
	*	Fakulteto pavadinimas
	*
	*	@param string
	*/
	string pavadinimas;

	/**
	*	Fakulteto studentu skaicius
	*
	*	@param int
	*/
	int studentuSkaicius;

	/**
	*	Fakulteto studentu masyvas
	*
	*	@param array
	*/
	Studentas studentai[maksimalusStudentuSkaiciusFakultete];

public:

	/**
	*	Klases konstruktorius
	*/
	Fakultetas(string pavadinimas): pavadinimas(pavadinimas), studentuSkaicius(0)
	{}

	/**
	*	Klases konstruktorius
	*/
	Fakultetas(): pavadinimas(""), studentuSkaicius(0)
	{}

	/**
	*	Studento registracios metodas.
	*
	*	Studentas studentas
	*/
	void registruotiStudenta(Studentas studentas)
	{
		this->studentai[this->studentuSkaicius ++] = studentas;
	}

	/**
	*	Metodas iðvedantis fakulteto pavadinima
	*
	*	@return string
	*/
	string isvestiFakultetoPavadinima()
	{
		return this->pavadinimas;
	}

	/**
	*	Metodas iðvedantis fakulteto studentu skaiciu
	*
	*	@return int
	*/
	int isvestiStudentuSkaiciu()
	{
		return this->studentuSkaicius;
	}

	/**
	*	Metodas iðvedantis fakulteto studenta
	*
	*	@return Studentas
	*/
	Studentas gautiStudentoInfo(int studentoNr )
	{
		if(abs(studentoNr) < this->studentuSkaicius){
			return this->studentai[abs(studentoNr)];
		}

		return *new Studentas("", 0, 0.0);
	}

	/**
	*	Metodas iðvedantis fakulteto studenta
	*
	*	@return Studentas
	*/
	Studentas imtiStudenta()
	{
		Studentas stud = this->studentai[0];
		this->studentuSkaicius --;
		for(int i = 0; i < this->studentuSkaicius; i ++){
			this->studentai[i] = this->studentai[i+1];
		}
		return stud;
	}

	/**
	*	Fakulteto studentu rikiavimo metodas.
	*/
	void rikiuotiFakultetoStudentus()
	{
		Studentas t;
		int nuo;
		for(int i = 0; i < this->studentuSkaicius - 1; i++) {
			nuo = i;
			for(int j = i+1; j < this->studentuSkaicius; j++)
				if (this->studentai[j] > this->studentai[nuo]) nuo = j;
			t = this->studentai[nuo];
			this->studentai[nuo] = this->studentai[i];
			this->studentai[i] = t;
		}
	}
};

	/**
	*	Giju masyvo elemento klase
	*/
class GijuMasyvoElementas
{

	/**
	*	Elemento kiekis
	*
	*	@param int
	*/
	int kiekis;

	/**
	*	Rikiuojamo lauko reiksme
	*
	*	@param Studentas
	*/
	string vardas;

public:

	/**
	*	Klases konstruktorius
	*/
	GijuMasyvoElementas(): kiekis(0), vardas("")
	{}

	/**
	*	Klases konstruktorius
	*
	*	@param string vardas
	*/
	GijuMasyvoElementas(string vardas)
	{
		this->kiekis = 0;
		this->detiElementa(vardas);
	}

	/**
	*	Metodas talpinantis elemento saugoma reiksme.
	*
	*	@param string vardas
	*/
	void detiElementa(string vardas){
		this->vardas = vardas;
		this->kiekis ++;
	}

	/**
	*	Metodas sumazinantis saugomos reiksmes kieki.
	*/
	void imtiElementa(){
		if(this->kiekis > 0){
			this->kiekis --;
		}
	}

	/**
	*	Metodas iðvedantis saugomo elemento kieki.
	*
	*	@return int
	*/
	int isvestiKieki()
	{
		return this->kiekis;
	}

	/**
	*	Metodas iðvedantis elemento pavadinima.
	*
	*	@return string
	*/
	string isvestiVarda()
	{
		return this->vardas;
	}

	/**
	*	Uzklotas operatorius >=.
	*
	*	@param GijuMasyvoElementas kitas
	*/
	bool GijuMasyvoElementas::operator >= (const GijuMasyvoElementas & kitas) 
	{
		return vardas >= kitas.vardas;
	}

	/**
	*	Uzklotas operatorius ==.
	*
	*	@param GijuMasyvoElementas kitas
	*/
	bool GijuMasyvoElementas::operator == (const GijuMasyvoElementas & kitas) 
	{
		return vardas == kitas.vardas;
	}
};

	/**
	*	Studento vardo klase
	*/
class Vardas
{
	/**
	*	Studento vardas.
	*
	*	@param string
	*/
	string vardas;

	/**
	*	Studentu turinèiø saugoma vardà kiekis.
	*
	*	@param int
	*/
	int kiekis;

public:

	/**
	*	Klases konstruktorius
	*/
	Vardas(): vardas(""), kiekis(0)
	{}

	/**
	*	Klases konstruktorius
	*/
	Vardas(string vardas, int kiekis): vardas(vardas), kiekis(kiekis)
	{}

	/**
	*	Metodas iðvedantis saugomo vardo reiksme.
	*/
	string gautiVarda()
	{
		return this->vardas;
	}

	/**
	*	Metodas iðvedantis studentu skaiciu, turinciu saugoma varda.
	*
	*	@return int
	*/
	int gautiKieki()
	{
		return this->kiekis;
	}

	/**
	*	Metodas maþinantis studentu skaiciu, turinciu saugoma varda.
	*/
	void mazintiKieki()
	{
		if(this->kiekis > 0){
			this->kiekis --;
		} else {
			this->kiekis = 0;
		}
	}
};
	
	/**
	*	Studentu vardu konteinerine klase
	*/
class Vardai
{

	/**
	*	Studentu vardu objektu masyvas.
	*
	*	@param Vardas[] vardai
	*/
	Vardas vardai[maksimalusFakultetuSkaicius];

	/**
	*	Studentu vardu objektu masyvo dydis.
	*
	*	@param int kiekis
	*/
	int kiekis;

public:

	/**
	*	Klases konstruktorius
	*/
	Vardai(): kiekis(0)
	{}

	/**
	*	Klases konstruktorius
	*/
	Vardai (Vardas vardas)
	{
		this->vardai[kiekis++] = vardas;
	}

	/**
	*	Metodas grazinantis nurodyta vardo objekta
	*
	*	@param int nr
	*
	*	@return Vardas
	*/
	Vardas gautiVarda(int nr)
	{
		return this->vardai[nr];
	}

	/**
	*	Metodas talpinantis nurodyta vardo objekta
	*
	*	@param Vardas vardas
	*/
	void talpintiVarda(Vardas vardas)
	{
		this->vardai[kiekis++] = vardas;
	}

	/**
	*	Metodas grazinantis studentu vardu objektu kieki
	*
	*	@return int
	*/
	int gautiKieki()
	{
		return this->kiekis;
	}

	/**
	*	Metodas sumazinantis nurodyto studento vardo objekto saugomu vardu kiekiu skaiciu.
	*
	*	@param int nt
	*/
	void mazintiKieki(int nr)
	{
		this->vardai[nr].mazintiKieki();
		if(this->vardai[nr].gautiKieki() == 0){
			this->kiekis --;
			for(int i = nr; i < this->kiekis; i ++){
				this->vardai[i] = this->vardai[i+1];
			}
		}
	}
};

	/**
	*	Metodas skaitantis duomenis ið duomenu failo
	*
	*	@param char duomenuFailas[]
	*	@param int fakultetuSkaicius
	*   @param Fakultetas fakultetai[]
	*   @param int varduMasyvuSkaicius
	*   @param Vardai vardai[]
	*/
void Skaityti(const char duomenuFailas[], int &fakultetuSkaicius, int &varduMasyvuSkaicius, Vardai vardai[], Fakultetas fakultetai[]);

	/**
	*	Metodas spausdinantis duomenis i rezultatu faila
	*
	*	@param char duomenuFailas[]
	*	@param Fakultetas fakultetas
	*/
void SpausdintiFakultetus(const char duomenuFailas[], Fakultetas *fakultetas);

	/**
	*	Metodas spausdinantis bendro giju masyvo duomenis i rezultatu faila
	*
	*	@param char duomenuFailas[]
	*	@param Gija bendrasGijuMasyvas
	*/
void SpausdintiGijuMasyva(const char duomenuFailas[], GijuMasyvoElementas bendrasGijuMasyvas[]);

	/**
	*	Metodas vykdomas kiekvienos gijos(destruktoriaus)
	*
	*	@param Vardai vardai
	*	@param GijuMasyvoElementas bendrasGijuMasyvas[]
	*   @param int varduMasyvuSkaicius
	*/
void VykdytiDestruktoriausGija(Vardai *vardai, GijuMasyvoElementas bendrasGijuMasyvas[], int varduMasyvuSkaicius);

	/**
	*	Metodas vykdomas kiekvienos gijos(konstruktoriaus)
	*
	*	@param Fakultetas fakultetas
	*	@param GijuMasyvoElementas bendrasGijuMasyvas[]
	*/
void VykdytiKonstruktoriausGija(Fakultetas *fakultetas, GijuMasyvoElementas bendrasGijuMasyvas[]);

	/**
	*	Metodas spausdinantis duomenis i rezultatu faila
	*
	*	@param char duomenuFailas[]
	*	@param Vardai vardai
	*/
void SpausdintiVardus(const char duomenuFailas[], Vardai *vardai);

	/**
	*	Metodas salinantis elementa is bendro giju masyvo
	*
	*	@param GijuMasyvoElementas bendrasGijuMasyvas[]
	*	@param GijuMasyvoElementas elementas
	*
	*   @return int
	*/
int imtiElementaIsBendroGijuMasyvo(GijuMasyvoElementas bendrasGijuMasyvas[], GijuMasyvoElementas elementas);

	/**
	*	Metodas grazinantis elemento vieta bendrame giju masyve
	*
	*	@param GijuMasyvoElementas bendrasGijuMasyvas[]
	*	@param GijuMasyvoElementas elementas
	*
	*   @return int
	*/
int rastiElementoVietaBendramGijuMasyve(GijuMasyvoElementas bendrasGijuMasyvas[], GijuMasyvoElementas elementas);

	/**
	*	Metodas iterpiantis elementa i bendra giju masyva
	*
	*	@param GijuMasyvoElementas bendrasGijuMasyvas[]
	*	@param GijuMasyvoElementas elementas
	*
	*   @return int
	*/
int iterptiElemetaBendramGijuMasyve(GijuMasyvoElementas bendrasGijuMasyvas[], GijuMasyvoElementas elementas);

	/**
	*	Metodas grazinantis elemento iterpimo vieta bendrame giju masyve
	*
	*	@param GijuMasyvoElementas bendrasGijuMasyvas[]
	*	@param GijuMasyvoElementas elementas
	*
	*   @return int
	*/
int rastiIterpimoVietaBendramGijuMasyve(GijuMasyvoElementas bendrasGijuMasyvas[], GijuMasyvoElementas elementas);

	/**
	*	Metodas laukiantis kol gija baigs savo darba
	*
	*	@param thread th
	*
	*   @return int
	*/
int LauktiGijosDarboPabaigos (thread *th);

int main()
{
	Fakultetas fakultetai[maksimalusFakultetuSkaicius];
	thread *gijos[maksimalusFakultetuSkaicius], *gijos2[maksimalusFakultetuSkaicius];
	int varduMasyvuSkaicius = 0, fakultetuSkaicius = 0;
	Vardai vardai[maksimalusFakultetuSkaicius];
	GijuMasyvoElementas bendrasGijuMasyvas[maksimalusGijuElementuSkaicius];
	Skaityti(duomenuFailas, fakultetuSkaicius, varduMasyvuSkaicius, vardai, fakultetai);
	ofstream fr(rezultatuFailas);
	fr.close();
	for(int i = 0; i < fakultetuSkaicius; i ++){
		fakultetai[i].rikiuotiFakultetoStudentus();
		SpausdintiFakultetus(rezultatuFailas, &fakultetai[i]);
	}
	for(int i = 0; i < varduMasyvuSkaicius; i ++){
		SpausdintiVardus(rezultatuFailas, &vardai[i]);
	}
	for(int i = 0; i < fakultetuSkaicius; i ++){
		gijos[i] = new thread(VykdytiKonstruktoriausGija, &fakultetai[i], bendrasGijuMasyvas);
	}
	for(int i = 0; i < varduMasyvuSkaicius; i ++){
		gijos2[i] = new thread(VykdytiDestruktoriausGija, &vardai[i], bendrasGijuMasyvas, varduMasyvuSkaicius);
	}
	for(int i = 0; i < fakultetuSkaicius; i ++){
		std::future<int> fut = async (LauktiGijosDarboPabaigos, gijos[i]);
	}
	RasymasBaigesi = true;
	for(int i = 0; i < varduMasyvuSkaicius; i ++){
		gijos2[i]->join();
	}
	SpausdintiGijuMasyva(rezultatuFailas, bendrasGijuMasyvas);
}

int LauktiGijosDarboPabaigos (thread *th)
{
	th->join();

	return 1;
}

void Skaityti(const char duomenuFailas[], int &fakultetuSkaicius, int &varduMasyvuSkaicius, Vardai vardai[], Fakultetas fakultetai[])
{
	 Studentas *studentas;
	 Fakultetas *fakultetas;
	 Vardas *vardas_obj;
	 Vardai* vardai_2;
	 string vardas, vardas_2;
	 double vidurkis;
	 bool fakultetuPabaiga = false;
	 int kursas;
	 int kiekis, kiekis_2;
	 ifstream fd(duomenuFailas);
	 while (!fd.eof()) {
		fd >> vardas >> kiekis;
		if(vardas == "-------------"){
			fd.ignore(80, '\n');
			fakultetuPabaiga = true;
			continue;
		}
		if(!fakultetuPabaiga){
			fakultetas = new Fakultetas(vardas);
			for(int i = 0; i < kiekis; i ++){
				fd >> vardas >> kursas >> vidurkis;
				studentas = new Studentas(vardas, kursas, vidurkis);
				fakultetas->registruotiStudenta(*studentas);
			}
			fakultetai[fakultetuSkaicius ++] = *fakultetas;
		} else {
			vardai_2 = new Vardai();
			for(int i = 0; i < kiekis; i ++){
				fd >> vardas_2 >> kiekis_2;
				vardas_obj = new Vardas(vardas_2, kiekis_2);
				vardai_2->talpintiVarda(*vardas_obj);
			}
			vardai[varduMasyvuSkaicius ++] = *vardai_2;
		}
	 }
	 fd.close();
}

void SpausdintiFakultetus(const char duomenuFailas[], Fakultetas *fakultetas)
{
	Studentas studentas;
	Vardas vardas;
	ofstream fr(duomenuFailas, ios::app);
	fr << "********" << setw(15) <<  fakultetas->isvestiFakultetoPavadinima() << "    ********" << endl;
	fr << "     Vardas   Kursas   Vidurkis   " << endl;
	for (int i = 0; i < fakultetas->isvestiStudentuSkaiciu(); i ++)
	{
		studentas = fakultetas->gautiStudentoInfo(i);
		fr  << right << setw(3) << i + 1 << ") "
			<< left << setw(10) << studentas.iðvestiStudentoVarda() << " "
			<< left << setw(9) << studentas.iðvestiStudentoKursa() << " "
			<< left << setw(9) << studentas.iðvestiStudentoVidurki() << endl;
	}
	fr.close();
}

void SpausdintiVardus(const char duomenuFailas[], Vardai *vardai)
{
	Vardas vardas;
	ofstream fr(duomenuFailas, ios::app);
	fr << "************************************" << endl;
	fr << "     Rikiuojamas_laukas   Kiekis   " << endl;
	for (int i = 0; i < vardai->gautiKieki(); i ++)
	{
		vardas = vardai->gautiVarda(i);
		fr  << right << setw(3) << i + 1 << ") "
			<< left << setw(22) << vardas.gautiVarda() << " "
			<< left << setw(9) << vardas.gautiKieki() << endl;
	}
	fr.close();
}

void SpausdintiGijuMasyva(const char duomenuFailas[], GijuMasyvoElementas bendrasGijuMasyvas[])
{
	GijuMasyvoElementas gijuMasyvoElementas;
	ofstream fr(duomenuFailas, ios::app);
	fr <<"--------------------------------"<<endl;
	fr <<"     Bendras Giju Masyvas       "<<endl;
	fr <<"--------------------------------"<<endl;
	fr <<"--------------------------------"<<endl;
	fr <<"     Rikiuojamas laukas   Kiekis"<<endl;
	fr <<"--------------------------------"<<endl;
	for (int i = 0; i < ElementuSkaiciusBendramGijuMasyve; i ++){
		gijuMasyvoElementas = bendrasGijuMasyvas[i];
		fr  << right << setw(3) << i + 1 << ") "
			<< left << setw(22) << gijuMasyvoElementas.isvestiVarda() << " "
			<< left << setw(9) << gijuMasyvoElementas.isvestiKieki() << endl;
	}
	fr.close();
}

int rastiIterpimoVietaBendramGijuMasyve(GijuMasyvoElementas bendrasGijuMasyvas[], GijuMasyvoElementas elementas)
{
	if(ElementuSkaiciusBendramGijuMasyve == 0){
		return 0;
	}
	for(int i = 0; i < ElementuSkaiciusBendramGijuMasyve; i ++){
		if(bendrasGijuMasyvas[i] >= elementas){
			return i;
		}
	}

	return ElementuSkaiciusBendramGijuMasyve;
}

int iterptiElemetaBendramGijuMasyve(GijuMasyvoElementas bendrasGijuMasyvas[], GijuMasyvoElementas elementas)
{
	int iterpiamoElementoNr = rastiIterpimoVietaBendramGijuMasyve(bendrasGijuMasyvas, elementas);
	if(bendrasGijuMasyvas[iterpiamoElementoNr] == elementas){
		bendrasGijuMasyvas[iterpiamoElementoNr].detiElementa(elementas.isvestiVarda());
		return 0;
	}
	if(ElementuSkaiciusBendramGijuMasyve+1 < maksimalusGijuElementuSkaicius){
		if(!ElementuSkaiciusBendramGijuMasyve == 0){
			for(int i = ElementuSkaiciusBendramGijuMasyve; i > iterpiamoElementoNr; i --){
				bendrasGijuMasyvas[i] = bendrasGijuMasyvas[i-1];
			}
		}
		bendrasGijuMasyvas[iterpiamoElementoNr] = elementas;
		ElementuSkaiciusBendramGijuMasyve++;
		return 0;
	}

	return -1;
}

int rastiElementoVietaBendramGijuMasyve(GijuMasyvoElementas bendrasGijuMasyvas[], GijuMasyvoElementas elementas)
{
	for(int i = 0; i < ElementuSkaiciusBendramGijuMasyve; i ++){
		if(bendrasGijuMasyvas[i] == elementas){
			return i;
		}
	}

	return -1;
}

int imtiElementaIsBendroGijuMasyvo(GijuMasyvoElementas bendrasGijuMasyvas[], GijuMasyvoElementas elementas)
{
	int ElementoNr = rastiElementoVietaBendramGijuMasyve(bendrasGijuMasyvas, elementas);
	if(ElementoNr == -1){
		return -1;
	}
	bendrasGijuMasyvas[ElementoNr].imtiElementa();
	if(bendrasGijuMasyvas[ElementoNr].isvestiKieki() == 0){
		ElementuSkaiciusBendramGijuMasyve --;
		for(int i = ElementoNr; i < ElementuSkaiciusBendramGijuMasyve; i ++){
			bendrasGijuMasyvas[i] = bendrasGijuMasyvas[i+1];
		}
		return 0;
	}

	return 1;
}

void VykdytiKonstruktoriausGija(Fakultetas *fakultetas, GijuMasyvoElementas bendrasGijuMasyvas[])
{
	Studentas studentas;
	GijuMasyvoElementas gijuMasyvoElementas;
	int elementasIterptas;
	while(fakultetas->isvestiStudentuSkaiciu() > 0){
		{
			while(ElementuSkaiciusBendramGijuMasyve < maksimalusGijuElementuSkaicius-1 && fakultetas->isvestiStudentuSkaiciu() > 0){
				{
					lock_guard<mutex> lock(Monitor);
					studentas = fakultetas->gautiStudentoInfo(0);
					gijuMasyvoElementas = *new GijuMasyvoElementas(studentas.iðvestiStudentoVarda());
					elementasIterptas = iterptiElemetaBendramGijuMasyve(bendrasGijuMasyvas, gijuMasyvoElementas);
					if(elementasIterptas == 0){
						fakultetas->imtiStudenta();
					}
				}
			}
		}
	}
}

void VykdytiDestruktoriausGija(Vardai *vardai, GijuMasyvoElementas bendrasGijuMasyvas[], int varduMasyvuSkaicius)
{
	Vardas vardas;
	int vardoNr = 0, counter = 0;
	int elementasPasalintas;
	GijuMasyvoElementas gijuMasyvoElementas;
	while(vardai->gautiKieki() > 0 && counter < 10000){
		{
			{
				lock_guard<mutex> lock(Monitor);
				vardoNr = 0;
				while(ElementuSkaiciusBendramGijuMasyve > 0 && vardai->gautiKieki() > vardoNr)
				{
					vardas = vardai->gautiVarda(vardoNr);
					gijuMasyvoElementas = *new GijuMasyvoElementas(vardas.gautiVarda());
					elementasPasalintas =  imtiElementaIsBendroGijuMasyvo(bendrasGijuMasyvas, gijuMasyvoElementas);
					if(elementasPasalintas != 0){
						vardoNr ++;
					} else {
						vardai->mazintiKieki(vardoNr);
					}
				}
			}
			if(RasymasBaigesi){
				counter ++;
			}
		}
	}
}