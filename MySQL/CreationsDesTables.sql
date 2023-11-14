-- Creation de la table Rencontre
CREATE TABLE IF NOT EXISTS P01_Rencontre(
    Match_Id INT AUTO_INCREMENT PRIMARY KEY,
    Date_Match DATE NOT NULL,
    Lieu VARCHAR(200) NOT NULL,
    Equipe1 VARCHAR(100) NOT NULL,
    Equipe2 VARCHAR(100) NOT NULL,
    Score1 INT NOT NULL,
    Score2 INT NOT NULL,
    Tour VARCHAR(20) NOT NULL
);
-- Creation de la table Equipe
CREATE TABLE IF NOT EXISTS P01_Equipe(
    Equipe_Id INT AUTO_INCREMENT PRIMARY KEY,
    Equipe_Nom VARCHAR(100) NOT NULL,
    Nb_Victoire INT NOT NULL,
    Nb_MatchNul INT NOT NULL,
    Nb_Defaite INT NOT NULL,
    Essai INT NOT NULL,
    Penalite INT NOT NULL,
    Transformation INT NOT NULL,
    Nb_Drop INT NOT NULL,
    Bonus_Defensif INT NOT NULL,
    Bonus_Offensif INT NOT NULL
);
-- Creation de la table Joueur
CREATE TABLE IF NOT EXISTS P01_Joueur(
    Joueur_Id INT AUTO_INCREMENT PRIMARY KEY,
    Joueur_Nom VARCHAR(200) NOT NULL,
    Joueur_Prenom VARCHAR(200) NOT NULL,
    Numero_Maillot INT NOT NULL,
    Poste VARCHAR(30),
    Equipe_Id INT NOT NULL,
    FOREIGN KEY (Equipe_Id) REFERENCES P01_Equipe(Equipe_Id)
);
-- Creation de la table MatchJoueurStat
CREATE TABLE IF NOT EXISTS P01_MatchJoueurStat(
    Match_Id INT NOT NULL,
    Joueur_Id INT NOT NULL,
    Poste VARCHAR(20) NOT NULL,
    Numero_Maillot VARCHAR(10) NOT NULL,
    Essai INT DEFAULT 0,
    Penalite INT DEFAULT 0,
    Transformation INT DEFAULT 0,
    Nb_Drop INT DEFAULT 0,
    FOREIGN KEY (Match_Id) REFERENCES P01_Rencontre(Match_Id),
    FOREIGN KEY (Joueur_Id) REFERENCES P01_Joueur(Joueur_Id),
    PRIMARY KEY (Match_Id,Joueur_Id)
);
-- Creation de la table Oppose
CREATE TABLE IF NOT EXISTS P01_Oppose(
    Match_Id INT NOT NULL,
    Equipe_Id INT NOT NULL,
    FOREIGN KEY (Match_Id) REFERENCES P01_Rencontre(Match_Id),
    FOREIGN KEY (Equipe_Id) REFERENCES P01_Equipe(Equipe_Id),
    PRIMARY KEY (Match_Id,Equipe_Id)
);
-- Creation de la table Appartient
CREATE TABLE IF NOT EXISTS P01_Appartient(
    Equipe_Id INT NOT NULL,
    Joueur_Id INT NOT NULL,
    FOREIGN KEY (Equipe_Id) REFERENCES P01_Equipe(Equipe_Id),
    FOREIGN KEY (Joueur_Id) REFERENCES P01_Joueur(Joueur_Id),
    PRIMARY KEY (Equipe_Id,Joueur_Id)
);