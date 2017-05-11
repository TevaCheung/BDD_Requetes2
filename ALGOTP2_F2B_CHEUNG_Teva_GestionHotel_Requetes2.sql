--Classement des clients par nombre d'occupations
Select CLI_NOM, CLI_PRENOM, T.CLI_ID, count(CHB_PLN_CLI_OCCUPE) NbOccupations
from T_CLIENT C, TJ_CHB_PLN_CLI T
where C.CLI_ID=T.CLI_ID
group by T.CLI_ID
order by NbOccupations desc;

--Classement des clients par montant dépensé dans l'hôtel
Select CL.CLI_ID, CLI_NOM, CLI_PRENOM, sum(TRF_CHB_PRIX) MontantDepense
from T_CLIENT CL, TJ_TRF_CHB P, T_CHAMBRE CH, TJ_CHB_PLN_CLI C
where C.CHB_ID=CH.CHB_ID
and CH.CHB_ID=C.CHB_ID
and C.CLI_ID=CL.CLI_ID
group by CL.CLI_ID
order by MontantDepense DESC;

--Classement des occupations par mois
Select cast(strftime('%m',PLN_JOUR) as integer) mois, count(CHB_PLN_CLI_OCCUPE) NbOccupations
from TJ_CHB_PLN_CLI
group by mois;

--Classement des occupations par trimestre


--Montant TTC de chaque ligne de facture avec remises
Select LIF_ID, FAC_ID, (LIF_MONTANT+LIF_REMISE_MONTANT+(LIF_MONTANT*(18.6/100))) CoutTotal
from T_LIGNE_FACTURE;

--Classement du montant total TTC avec remises des factures
Select FAC_ID, sum(LIF_MONTANT+LIF_REMISE_MONTANT+(LIF_MONTANT*(18.6/100))) CoutTotal
from T_LIGNE_FACTURE
group by FAC_ID;

-- Tarif moyen des chambres par années croissantes
Select CHB_ID, avg(TRF_CHB_PRIX) PrixMoy, cast(strftime('%Y',TRF_DATE_DEBUT) as integer) annee
from TJ_TRF_CHB
group by annee asc;

--Tarif moyen des chambres par étage et années croissantes

--Chambre la plus chère et en quelle année
Select CHB_ID RefChambre, max(TRF_CHB_PRIX) PrixLePlusCher, strftime('%Y',TRF_DATE_DEBUT) Annee
from TJ_TRF_CHB;

--Chambres réservées mais pas occupées
Select CHB_ID, PLN_JOUR, T1.CLI_ID, CLI_NOM, CLI_PRENOM
from TJ_CHB_PLN_CLI T1, T_CLIENT T2
where T1.CLI_ID=T2.CLI_ID
and CHB_PLN_CLI_RESERVE=1
and CHB_PLN_CLI_OCCUPE=0;

--Taux de résa par chambres

--Factures réglées avant leur édition
Select FAC_ID, FAC_DATE DateEmission, FAC_PMT_DATE DateReglement
from T_FACTURE
where strftime('%s',DateEmission)-strftime('%s',DateReglement)<0; 

--Par qui ont été payées les factures réglées en avance ?
Select FAC_ID CodeFact, CLI_ID RefClient, CLI_NOM NomClient, CLI_PRENOM PrenomClient
from T_FACTURE F, T_CLIENT C
where strftime('%s',DateEmission)-strftime('%s',DateReglement)<0; 
and F.CLI_ID=C.CLI_ID;

--Classment des modes de paiement (par mode et montant total généré)


--ajout client
insert into T_CLIENT values (1000,'CHEUNG','Teva',NULL,'M.');

--moyens de com
insert into T_EMAIL values (1000,1000,'teva.cheung0@gmail.com','domicile');
insert into T_TELEPHONE values (1000,1000,'TEL','01-12-12-12-12','domicile');

--nouvelle chb à date du jour
insert into T_CHAMBRE values (666,666,'6e',1,1,1,2,666);

--3 occupants, maximum de confort, prix=30% en plus du prix maximal 
insert into TJ_CHB_PLN_CLI values (666,'2017-05-11',1000,3,1,1);
update T_CHAMBRE
set CHB_BAIN=1
	CHB_DOUCHE=1
	CHB_WC=1
where CHB_ID=666;
insert into TJ_TRF_CHB values (666,'2017-05-11',max(TRF_CHB_PRIX)+max(TRF_CHB_PRIX)*(30/100));

-- reglement par CB
insert into T_FACTURE (FAC_ID,CLI_ID,PMT_CODE,FAC_DATE,FAC_PMT_DATE) values
(1000,1000,'CB','2017-05-11','2017-05-11');
insert into T_LIGNE_FACTURE values (1000,1000,1,0,0,240,18.6);

--2nde facture editee car tarif a changé : rabais de 10%
update T_LIGNE_FACTURE
set LIF_REMISE_POURCENT=10
set LIF_REMISE_MONTANT=LIF_MONTANT*(LIF_REMISE_POURCENT/100)
where LIF_ID=1000;
--Comment faites-vous ?
--Les tables avec des clés étrangères (dépendantes d'autres) sont à remplir en dernier
--Un ordre d'jout pourrait etre : client, chambre, email, telephone et les informations des tables de jointure
