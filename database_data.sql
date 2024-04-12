PGDMP                      |           MOOC BDD    16.1    16.1 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    18032    MOOC BDD    DATABASE     l   CREATE DATABASE "MOOC BDD" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C';
    DROP DATABASE "MOOC BDD";
                postgres    false            �           0    0    MOOC BDD    DATABASE PROPERTIES     1   ALTER DATABASE "MOOC BDD" CONNECTION LIMIT = 10;
                     postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                pg_database_owner    false            �           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                   pg_database_owner    false    4            �            1255    32799    check_maximumplaces_function()    FUNCTION     �  CREATE FUNCTION public.check_maximumplaces_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    used_places INT;
BEGIN
    -- 计算这个会话已经使用的位置数
    SELECT COUNT(*) INTO used_places
    FROM session_direct_Utilisateurs
    WHERE session_direct_Id_session_direct = NEW.Id_session_direct;

    -- 如果已使用的位置数大于或等于最大位置数，则抛出异常
    IF NEW.Nombre_de_placesmaximum <= used_places THEN
        RAISE EXCEPTION 'Le nombre maximum de places est inférieur au nombre de places déjà utilisées.';
    END IF;
    
    -- 如果没有问题，则继续插入操作
    RETURN NEW;
END;
$$;
 5   DROP FUNCTION public.check_maximumplaces_function();
       public          postgres    false    4            �            1255    32794    check_placesmaximum()    FUNCTION     �  CREATE FUNCTION public.check_placesmaximum() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- 假设 'max_places' 和 'used_places' 是 session_direct 表的字段
    -- 你需要根据你的实际情况调整条件检查逻辑
    IF NEW.max_places < (SELECT COUNT(*) FROM session_direct WHERE some_condition) THEN
        RAISE EXCEPTION '超过最大可用位置';
    END IF;
    RETURN NEW;
END;
$$;
 ,   DROP FUNCTION public.check_placesmaximum();
       public          postgres    false    4            �            1255    32803 &   check_tentative_utilisateur_autorise()    FUNCTION     �   CREATE FUNCTION public.check_tentative_utilisateur_autorise() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    is_associated INT;
BEGIN
    -- 你的逻辑...
    RETURN NEW;
END;
$$;
 =   DROP FUNCTION public.check_tentative_utilisateur_autorise();
       public          postgres    false    4            �            1255    32802 '   check_tentatives_utilisateur_autorise()    FUNCTION     �   CREATE FUNCTION public.check_tentatives_utilisateur_autorise() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    is_associated INT;
BEGIN
    -- 你的逻辑...
    RETURN NEW;
END;
$$;
 >   DROP FUNCTION public.check_tentatives_utilisateur_autorise();
       public          postgres    false    4            �            1255    32811    set_statut_de_reussite()    FUNCTION       CREATE FUNCTION public.set_statut_de_reussite() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.Score >= 40 THEN
        NEW.Statut_de_reussite := 'validé';
    ELSE
        NEW.Statut_de_reussite := 'non_validé';
    END IF;
    RETURN NEW;
END;
$$;
 /   DROP FUNCTION public.set_statut_de_reussite();
       public          postgres    false    4            �            1259    18033    assignation    TABLE     h   CREATE TABLE public.assignation (
    cours_id integer NOT NULL,
    utilisateur_id integer NOT NULL
);
    DROP TABLE public.assignation;
       public         heap    postgres    false    4            �            1259    18039    chapitre    TABLE     �   CREATE TABLE public.chapitre (
    id integer NOT NULL,
    ordrechapitre integer NOT NULL,
    chapitrenom character varying(100) NOT NULL,
    cours_id integer NOT NULL
);
    DROP TABLE public.chapitre;
       public         heap    postgres    false    4            �            1259    18038    chapitre_id_seq    SEQUENCE     �   CREATE SEQUENCE public.chapitre_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.chapitre_id_seq;
       public          postgres    false    4    217            �           0    0    chapitre_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.chapitre_id_seq OWNED BY public.chapitre.id;
          public          postgres    false    216            �            1259    18221    chapitre_seq    SEQUENCE     u   CREATE SEQUENCE public.chapitre_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.chapitre_seq;
       public          postgres    false    4            �            1259    18046    cours    TABLE     D  CREATE TABLE public.cours (
    id integer NOT NULL,
    intitule character varying(255) NOT NULL,
    description text NOT NULL,
    prerequis text NOT NULL,
    prix numeric(5,2) NOT NULL,
    accessibilite boolean NOT NULL,
    datedebut date,
    datefin date,
    CONSTRAINT check_dates CHECK ((datedebut <= datefin)),
    CONSTRAINT check_intitule_length CHECK ((length((intitule)::text) <= 50)),
    CONSTRAINT check_intitule_not_empty CHECK (((intitule IS NOT NULL) AND (TRIM(BOTH FROM intitule) <> ''::text))),
    CONSTRAINT check_prix CHECK ((prix >= (0)::numeric))
);
    DROP TABLE public.cours;
       public         heap    postgres    false    4            �            1259    18045    cours_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cours_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.cours_id_seq;
       public          postgres    false    4    219            �           0    0    cours_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.cours_id_seq OWNED BY public.cours.id;
          public          postgres    false    218            �            1259    18222 	   cours_seq    SEQUENCE     r   CREATE SEQUENCE public.cours_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
     DROP SEQUENCE public.cours_seq;
       public          postgres    false    4            �            1259    18054    creation    TABLE     }   CREATE TABLE public.creation (
    cours_id integer NOT NULL,
    utilisateur_id integer NOT NULL,
    date date NOT NULL
);
    DROP TABLE public.creation;
       public         heap    postgres    false    4            �            1259    18059 
   evaluation    TABLE     �   CREATE TABLE public.evaluation (
    utilisateur_id integer NOT NULL,
    cours_id integer NOT NULL,
    note numeric(10,1),
    commentaire text,
    CONSTRAINT encadrement_note CHECK (((note >= (1)::numeric) AND (note <= (5)::numeric)))
);
    DROP TABLE public.evaluation;
       public         heap    postgres    false    4            �            1259    18067    examen    TABLE     ,  CREATE TABLE public.examen (
    id integer NOT NULL,
    titreexamen character varying(70) NOT NULL,
    contenu text NOT NULL,
    scoremin numeric(100,10) NOT NULL,
    partie_id integer NOT NULL,
    CONSTRAINT check_contenu_not_empty CHECK (((contenu IS NOT NULL) AND (contenu <> ''::text)))
);
    DROP TABLE public.examen;
       public         heap    postgres    false    4            �            1259    18066    examen_id_seq    SEQUENCE     �   CREATE SEQUENCE public.examen_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.examen_id_seq;
       public          postgres    false    223    4            �           0    0    examen_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.examen_id_seq OWNED BY public.examen.id;
          public          postgres    false    222            �            1259    18223 
   examen_seq    SEQUENCE     s   CREATE SEQUENCE public.examen_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 !   DROP SEQUENCE public.examen_seq;
       public          postgres    false    4            �            1259    18076    inscription_cours    TABLE       CREATE TABLE public.inscription_cours (
    id integer NOT NULL,
    dateinscription date NOT NULL,
    datepayant date,
    payant boolean NOT NULL,
    typestatut character varying(25) NOT NULL,
    utilisateur_id integer NOT NULL,
    session_direct_id integer NOT NULL
);
 %   DROP TABLE public.inscription_cours;
       public         heap    postgres    false    4            �            1259    18075    inscription_cours_id_seq    SEQUENCE     �   CREATE SEQUENCE public.inscription_cours_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.inscription_cours_id_seq;
       public          postgres    false    4    225            �           0    0    inscription_cours_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.inscription_cours_id_seq OWNED BY public.inscription_cours.id;
          public          postgres    false    224            �            1259    18224    inscription_cours_seq    SEQUENCE     ~   CREATE SEQUENCE public.inscription_cours_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.inscription_cours_seq;
       public          postgres    false    4            �            1259    18083    partie    TABLE     �   CREATE TABLE public.partie (
    id integer NOT NULL,
    ordrepartie integer NOT NULL,
    titrepartie character varying(70) NOT NULL,
    contenu text NOT NULL,
    chapitre_id integer NOT NULL
);
    DROP TABLE public.partie;
       public         heap    postgres    false    4            �            1259    18082    partie_id_seq    SEQUENCE     �   CREATE SEQUENCE public.partie_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.partie_id_seq;
       public          postgres    false    227    4            �           0    0    partie_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.partie_id_seq OWNED BY public.partie.id;
          public          postgres    false    226            �            1259    18225 
   partie_seq    SEQUENCE     s   CREATE SEQUENCE public.partie_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 !   DROP SEQUENCE public.partie_seq;
       public          postgres    false    4            �            1259    18092    progression    TABLE     �   CREATE TABLE public.progression (
    id integer NOT NULL,
    termine boolean NOT NULL,
    date date NOT NULL,
    partie_id integer NOT NULL,
    inscription_cours_id integer NOT NULL
);
    DROP TABLE public.progression;
       public         heap    postgres    false    4            �            1259    18091    progression_id_seq    SEQUENCE     �   CREATE SEQUENCE public.progression_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.progression_id_seq;
       public          postgres    false    229    4            �           0    0    progression_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.progression_id_seq OWNED BY public.progression.id;
          public          postgres    false    228            �            1259    18226    progression_seq    SEQUENCE     x   CREATE SEQUENCE public.progression_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.progression_seq;
       public          postgres    false    4            �            1259    18099    role    TABLE     b   CREATE TABLE public.role (
    id integer NOT NULL,
    libelle character varying(30) NOT NULL
);
    DROP TABLE public.role;
       public         heap    postgres    false    4            �            1259    18098    role_id_seq    SEQUENCE     �   CREATE SEQUENCE public.role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.role_id_seq;
       public          postgres    false    231    4            �           0    0    role_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.role_id_seq OWNED BY public.role.id;
          public          postgres    false    230            �            1259    18105    role_utilisateur    TABLE     m   CREATE TABLE public.role_utilisateur (
    utilisateur_id integer NOT NULL,
    roles_id integer NOT NULL
);
 $   DROP TABLE public.role_utilisateur;
       public         heap    postgres    false    4            �            1259    18227 	   roles_seq    SEQUENCE     r   CREATE SEQUENCE public.roles_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
     DROP SEQUENCE public.roles_seq;
       public          postgres    false    4            �            1259    18111    session_direct    TABLE     T  CREATE TABLE public.session_direct (
    id integer NOT NULL,
    typesession character varying(30) NOT NULL,
    datedebut timestamp without time zone NOT NULL,
    datefin timestamp without time zone NOT NULL,
    placesmaximum integer NOT NULL,
    cours_id integer NOT NULL,
    CONSTRAINT check_heures CHECK ((datedebut < datefin))
);
 "   DROP TABLE public.session_direct;
       public         heap    postgres    false    4            �            1259    18110    session_direct_id_seq    SEQUENCE     �   CREATE SEQUENCE public.session_direct_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.session_direct_id_seq;
       public          postgres    false    234    4            �           0    0    session_direct_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.session_direct_id_seq OWNED BY public.session_direct.id;
          public          postgres    false    233            �            1259    18228    session_direct_seq    SEQUENCE     {   CREATE SEQUENCE public.session_direct_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.session_direct_seq;
       public          postgres    false    4            �            1259    18118 	   tentative    TABLE     �  CREATE TABLE public.tentative (
    id integer NOT NULL,
    date date NOT NULL,
    score numeric(100,10) NOT NULL,
    procedure character varying(70) NOT NULL,
    examen_id integer NOT NULL,
    inscription_cours_id integer NOT NULL,
    statut_de_reussite text,
    CONSTRAINT check_statut_reussite CHECK ((statut_de_reussite = ANY (ARRAY['validé'::text, 'non_validé'::text]))),
    CONSTRAINT score CHECK (((score >= (0)::numeric) AND (score <= (100)::numeric)))
);
    DROP TABLE public.tentative;
       public         heap    postgres    false    4            �            1259    18117    tentative_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tentative_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.tentative_id_seq;
       public          postgres    false    4    236            �           0    0    tentative_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.tentative_id_seq OWNED BY public.tentative.id;
          public          postgres    false    235            �            1259    18229    tentative_seq    SEQUENCE     v   CREATE SEQUENCE public.tentative_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.tentative_seq;
       public          postgres    false    4            �            1259    18125    utilisateur    TABLE       CREATE TABLE public.utilisateur (
    id integer NOT NULL,
    nom character varying(100) NOT NULL,
    prenom character varying(100) NOT NULL,
    email character varying(50) NOT NULL,
    datenaissance date NOT NULL,
    numerotelephone character varying(15) NOT NULL,
    location character varying(8) NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(50) NOT NULL,
    CONSTRAINT chk_email CHECK (((email)::text ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text))
);
    DROP TABLE public.utilisateur;
       public         heap    postgres    false    4            �            1259    18124    utilisateur_id_seq    SEQUENCE     �   CREATE SEQUENCE public.utilisateur_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.utilisateur_id_seq;
       public          postgres    false    4    238            �           0    0    utilisateur_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.utilisateur_id_seq OWNED BY public.utilisateur.id;
          public          postgres    false    237            �            1259    18230    utilisateur_seq    SEQUENCE     x   CREATE SEQUENCE public.utilisateur_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.utilisateur_seq;
       public          postgres    false    4            �           2604    18042    chapitre id    DEFAULT     j   ALTER TABLE ONLY public.chapitre ALTER COLUMN id SET DEFAULT nextval('public.chapitre_id_seq'::regclass);
 :   ALTER TABLE public.chapitre ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    217    217            �           2604    18049    cours id    DEFAULT     d   ALTER TABLE ONLY public.cours ALTER COLUMN id SET DEFAULT nextval('public.cours_id_seq'::regclass);
 7   ALTER TABLE public.cours ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    219    218    219            �           2604    18070 	   examen id    DEFAULT     f   ALTER TABLE ONLY public.examen ALTER COLUMN id SET DEFAULT nextval('public.examen_id_seq'::regclass);
 8   ALTER TABLE public.examen ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    223    222    223            �           2604    18079    inscription_cours id    DEFAULT     |   ALTER TABLE ONLY public.inscription_cours ALTER COLUMN id SET DEFAULT nextval('public.inscription_cours_id_seq'::regclass);
 C   ALTER TABLE public.inscription_cours ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    225    224    225            �           2604    18086 	   partie id    DEFAULT     f   ALTER TABLE ONLY public.partie ALTER COLUMN id SET DEFAULT nextval('public.partie_id_seq'::regclass);
 8   ALTER TABLE public.partie ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    227    226    227            �           2604    18095    progression id    DEFAULT     p   ALTER TABLE ONLY public.progression ALTER COLUMN id SET DEFAULT nextval('public.progression_id_seq'::regclass);
 =   ALTER TABLE public.progression ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    228    229    229            �           2604    18102    role id    DEFAULT     b   ALTER TABLE ONLY public.role ALTER COLUMN id SET DEFAULT nextval('public.role_id_seq'::regclass);
 6   ALTER TABLE public.role ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    230    231    231            �           2604    18114    session_direct id    DEFAULT     v   ALTER TABLE ONLY public.session_direct ALTER COLUMN id SET DEFAULT nextval('public.session_direct_id_seq'::regclass);
 @   ALTER TABLE public.session_direct ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    234    233    234            �           2604    18121    tentative id    DEFAULT     l   ALTER TABLE ONLY public.tentative ALTER COLUMN id SET DEFAULT nextval('public.tentative_id_seq'::regclass);
 ;   ALTER TABLE public.tentative ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    235    236    236            �           2604    18128    utilisateur id    DEFAULT     p   ALTER TABLE ONLY public.utilisateur ALTER COLUMN id SET DEFAULT nextval('public.utilisateur_id_seq'::regclass);
 =   ALTER TABLE public.utilisateur ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    237    238    238            �          0    18033    assignation 
   TABLE DATA           ?   COPY public.assignation (cours_id, utilisateur_id) FROM stdin;
    public          postgres    false    215   �       �          0    18039    chapitre 
   TABLE DATA           L   COPY public.chapitre (id, ordrechapitre, chapitrenom, cours_id) FROM stdin;
    public          postgres    false    217   _�       �          0    18046    cours 
   TABLE DATA           n   COPY public.cours (id, intitule, description, prerequis, prix, accessibilite, datedebut, datefin) FROM stdin;
    public          postgres    false    219   �       �          0    18054    creation 
   TABLE DATA           B   COPY public.creation (cours_id, utilisateur_id, date) FROM stdin;
    public          postgres    false    220   �       �          0    18059 
   evaluation 
   TABLE DATA           Q   COPY public.evaluation (utilisateur_id, cours_id, note, commentaire) FROM stdin;
    public          postgres    false    221   c�       �          0    18067    examen 
   TABLE DATA           O   COPY public.examen (id, titreexamen, contenu, scoremin, partie_id) FROM stdin;
    public          postgres    false    223   y�       �          0    18076    inscription_cours 
   TABLE DATA           �   COPY public.inscription_cours (id, dateinscription, datepayant, payant, typestatut, utilisateur_id, session_direct_id) FROM stdin;
    public          postgres    false    225   �       �          0    18083    partie 
   TABLE DATA           T   COPY public.partie (id, ordrepartie, titrepartie, contenu, chapitre_id) FROM stdin;
    public          postgres    false    227   �       �          0    18092    progression 
   TABLE DATA           Y   COPY public.progression (id, termine, date, partie_id, inscription_cours_id) FROM stdin;
    public          postgres    false    229   ,�       �          0    18099    role 
   TABLE DATA           +   COPY public.role (id, libelle) FROM stdin;
    public          postgres    false    231   ��       �          0    18105    role_utilisateur 
   TABLE DATA           D   COPY public.role_utilisateur (utilisateur_id, roles_id) FROM stdin;
    public          postgres    false    232   8�       �          0    18111    session_direct 
   TABLE DATA           f   COPY public.session_direct (id, typesession, datedebut, datefin, placesmaximum, cours_id) FROM stdin;
    public          postgres    false    234   ��       �          0    18118 	   tentative 
   TABLE DATA           t   COPY public.tentative (id, date, score, procedure, examen_id, inscription_cours_id, statut_de_reussite) FROM stdin;
    public          postgres    false    236   ŵ       �          0    18125    utilisateur 
   TABLE DATA           {   COPY public.utilisateur (id, nom, prenom, email, datenaissance, numerotelephone, location, username, password) FROM stdin;
    public          postgres    false    238   ŷ       �           0    0    chapitre_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.chapitre_id_seq', 41, true);
          public          postgres    false    216            �           0    0    chapitre_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.chapitre_seq', 1, false);
          public          postgres    false    239            �           0    0    cours_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.cours_id_seq', 50, true);
          public          postgres    false    218            �           0    0 	   cours_seq    SEQUENCE SET     8   SELECT pg_catalog.setval('public.cours_seq', 1, false);
          public          postgres    false    240            �           0    0    examen_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.examen_id_seq', 31, true);
          public          postgres    false    222            �           0    0 
   examen_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.examen_seq', 1, false);
          public          postgres    false    241            �           0    0    inscription_cours_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.inscription_cours_id_seq', 30, true);
          public          postgres    false    224            �           0    0    inscription_cours_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.inscription_cours_seq', 1, false);
          public          postgres    false    242            �           0    0    partie_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.partie_id_seq', 31, true);
          public          postgres    false    226            �           0    0 
   partie_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.partie_seq', 1, false);
          public          postgres    false    243            �           0    0    progression_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.progression_id_seq', 30, true);
          public          postgres    false    228            �           0    0    progression_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.progression_seq', 1, false);
          public          postgres    false    244            �           0    0    role_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.role_id_seq', 20, true);
          public          postgres    false    230            �           0    0 	   roles_seq    SEQUENCE SET     8   SELECT pg_catalog.setval('public.roles_seq', 1, false);
          public          postgres    false    245            �           0    0    session_direct_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.session_direct_id_seq', 1060, true);
          public          postgres    false    233            �           0    0    session_direct_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.session_direct_seq', 1, false);
          public          postgres    false    246            �           0    0    tentative_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.tentative_id_seq', 32, true);
          public          postgres    false    235            �           0    0    tentative_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.tentative_seq', 1, false);
          public          postgres    false    247            �           0    0    utilisateur_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.utilisateur_id_seq', 4, true);
          public          postgres    false    237            �           0    0    utilisateur_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.utilisateur_seq', 1, false);
          public          postgres    false    248            �           2606    18037    assignation assignation_pk 
   CONSTRAINT     n   ALTER TABLE ONLY public.assignation
    ADD CONSTRAINT assignation_pk PRIMARY KEY (cours_id, utilisateur_id);
 D   ALTER TABLE ONLY public.assignation DROP CONSTRAINT assignation_pk;
       public            postgres    false    215    215            �           2606    18044    chapitre chapitre_pk 
   CONSTRAINT     R   ALTER TABLE ONLY public.chapitre
    ADD CONSTRAINT chapitre_pk PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.chapitre DROP CONSTRAINT chapitre_pk;
       public            postgres    false    217            �           2606    18053    cours cours_pk 
   CONSTRAINT     L   ALTER TABLE ONLY public.cours
    ADD CONSTRAINT cours_pk PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.cours DROP CONSTRAINT cours_pk;
       public            postgres    false    219            �           2606    18058    creation creation_pk 
   CONSTRAINT     h   ALTER TABLE ONLY public.creation
    ADD CONSTRAINT creation_pk PRIMARY KEY (cours_id, utilisateur_id);
 >   ALTER TABLE ONLY public.creation DROP CONSTRAINT creation_pk;
       public            postgres    false    220    220            �           2606    18065    evaluation evaluation_pk 
   CONSTRAINT     l   ALTER TABLE ONLY public.evaluation
    ADD CONSTRAINT evaluation_pk PRIMARY KEY (utilisateur_id, cours_id);
 B   ALTER TABLE ONLY public.evaluation DROP CONSTRAINT evaluation_pk;
       public            postgres    false    221    221            �           2606    18074    examen examen_pk 
   CONSTRAINT     N   ALTER TABLE ONLY public.examen
    ADD CONSTRAINT examen_pk PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.examen DROP CONSTRAINT examen_pk;
       public            postgres    false    223            �           2606    18081 &   inscription_cours inscription_cours_pk 
   CONSTRAINT     d   ALTER TABLE ONLY public.inscription_cours
    ADD CONSTRAINT inscription_cours_pk PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.inscription_cours DROP CONSTRAINT inscription_cours_pk;
       public            postgres    false    225            �           2606    18090    partie partie_pk 
   CONSTRAINT     N   ALTER TABLE ONLY public.partie
    ADD CONSTRAINT partie_pk PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.partie DROP CONSTRAINT partie_pk;
       public            postgres    false    227            �           2606    18097    progression progression_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.progression
    ADD CONSTRAINT progression_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.progression DROP CONSTRAINT progression_pk;
       public            postgres    false    229            �           2606    18109 $   role_utilisateur role_utilisateur_pk 
   CONSTRAINT     x   ALTER TABLE ONLY public.role_utilisateur
    ADD CONSTRAINT role_utilisateur_pk PRIMARY KEY (utilisateur_id, roles_id);
 N   ALTER TABLE ONLY public.role_utilisateur DROP CONSTRAINT role_utilisateur_pk;
       public            postgres    false    232    232            �           2606    18104    role roles_pk 
   CONSTRAINT     K   ALTER TABLE ONLY public.role
    ADD CONSTRAINT roles_pk PRIMARY KEY (id);
 7   ALTER TABLE ONLY public.role DROP CONSTRAINT roles_pk;
       public            postgres    false    231            �           2606    18116     session_direct session_direct_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.session_direct
    ADD CONSTRAINT session_direct_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.session_direct DROP CONSTRAINT session_direct_pk;
       public            postgres    false    234            �           2606    18123    tentative tentative_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.tentative
    ADD CONSTRAINT tentative_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.tentative DROP CONSTRAINT tentative_pk;
       public            postgres    false    236            �           2606    18130    utilisateur utilisateur_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.utilisateur
    ADD CONSTRAINT utilisateur_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.utilisateur DROP CONSTRAINT utilisateur_pk;
       public            postgres    false    238                       2620    32801 *   session_direct check_maximumplaces_trigger    TRIGGER     �   CREATE TRIGGER check_maximumplaces_trigger BEFORE INSERT ON public.session_direct FOR EACH ROW EXECUTE FUNCTION public.check_maximumplaces_function();
 C   DROP TRIGGER check_maximumplaces_trigger ON public.session_direct;
       public          postgres    false    234    250                       2620    32795 *   session_direct check_placesmaximum_trigger    TRIGGER     �   CREATE TRIGGER check_placesmaximum_trigger BEFORE INSERT ON public.session_direct FOR EACH ROW EXECUTE FUNCTION public.check_placesmaximum();
 C   DROP TRIGGER check_placesmaximum_trigger ON public.session_direct;
       public          postgres    false    249    234                       2620    32798 1   session_direct check_placesmaximum_update_trigger    TRIGGER     �   CREATE TRIGGER check_placesmaximum_update_trigger BEFORE UPDATE ON public.session_direct FOR EACH ROW EXECUTE FUNCTION public.check_placesmaximum();
 J   DROP TRIGGER check_placesmaximum_update_trigger ON public.session_direct;
       public          postgres    false    249    234                       2620    32804 .   tentative check_tentative_utilisateur_autorise    TRIGGER     �   CREATE TRIGGER check_tentative_utilisateur_autorise BEFORE INSERT ON public.tentative FOR EACH ROW EXECUTE FUNCTION public.check_tentative_utilisateur_autorise();
 G   DROP TRIGGER check_tentative_utilisateur_autorise ON public.tentative;
       public          postgres    false    252    236                       2620    32812 (   tentative set_statut_de_reussite_trigger    TRIGGER     �   CREATE TRIGGER set_statut_de_reussite_trigger BEFORE INSERT OR UPDATE ON public.tentative FOR EACH ROW EXECUTE FUNCTION public.set_statut_de_reussite();
 A   DROP TRIGGER set_statut_de_reussite_trigger ON public.tentative;
       public          postgres    false    236    253            �           2606    18131    progression avoir    FK CONSTRAINT     �   ALTER TABLE ONLY public.progression
    ADD CONSTRAINT avoir FOREIGN KEY (inscription_cours_id) REFERENCES public.inscription_cours(id);
 ;   ALTER TABLE ONLY public.progression DROP CONSTRAINT avoir;
       public          postgres    false    225    229    3552            �           2606    18136    chapitre chapitres_cours    FK CONSTRAINT     x   ALTER TABLE ONLY public.chapitre
    ADD CONSTRAINT chapitres_cours FOREIGN KEY (cours_id) REFERENCES public.cours(id);
 B   ALTER TABLE ONLY public.chapitre DROP CONSTRAINT chapitres_cours;
       public          postgres    false    219    3544    217            �           2606    18141    creation cours_association_1    FK CONSTRAINT     |   ALTER TABLE ONLY public.creation
    ADD CONSTRAINT cours_association_1 FOREIGN KEY (cours_id) REFERENCES public.cours(id);
 F   ALTER TABLE ONLY public.creation DROP CONSTRAINT cours_association_1;
       public          postgres    false    220    3544    219            �           2606    18146    assignation cours_association_2    FK CONSTRAINT        ALTER TABLE ONLY public.assignation
    ADD CONSTRAINT cours_association_2 FOREIGN KEY (cours_id) REFERENCES public.cours(id);
 I   ALTER TABLE ONLY public.assignation DROP CONSTRAINT cours_association_2;
       public          postgres    false    215    219    3544            �           2606    18151    inscription_cours de    FK CONSTRAINT     �   ALTER TABLE ONLY public.inscription_cours
    ADD CONSTRAINT de FOREIGN KEY (session_direct_id) REFERENCES public.session_direct(id);
 >   ALTER TABLE ONLY public.inscription_cours DROP CONSTRAINT de;
       public          postgres    false    225    3562    234            �           2606    18156    evaluation evaluation_cours    FK CONSTRAINT     {   ALTER TABLE ONLY public.evaluation
    ADD CONSTRAINT evaluation_cours FOREIGN KEY (cours_id) REFERENCES public.cours(id);
 E   ALTER TABLE ONLY public.evaluation DROP CONSTRAINT evaluation_cours;
       public          postgres    false    221    3544    219            �           2606    18161    examen examen_partie    FK CONSTRAINT     v   ALTER TABLE ONLY public.examen
    ADD CONSTRAINT examen_partie FOREIGN KEY (partie_id) REFERENCES public.partie(id);
 >   ALTER TABLE ONLY public.examen DROP CONSTRAINT examen_partie;
       public          postgres    false    223    227    3554            �           2606    32788 &   inscription_cours fk_session_direct_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.inscription_cours
    ADD CONSTRAINT fk_session_direct_id FOREIGN KEY (session_direct_id) REFERENCES public.session_direct(id) ON UPDATE CASCADE ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.inscription_cours DROP CONSTRAINT fk_session_direct_id;
       public          postgres    false    225    234    3562                        2606    18166    tentative inscription_tentative    FK CONSTRAINT     �   ALTER TABLE ONLY public.tentative
    ADD CONSTRAINT inscription_tentative FOREIGN KEY (inscription_cours_id) REFERENCES public.inscription_cours(id);
 I   ALTER TABLE ONLY public.tentative DROP CONSTRAINT inscription_tentative;
       public          postgres    false    236    3552    225            �           2606    18171    inscription_cours inscrire    FK CONSTRAINT     �   ALTER TABLE ONLY public.inscription_cours
    ADD CONSTRAINT inscrire FOREIGN KEY (utilisateur_id) REFERENCES public.utilisateur(id);
 D   ALTER TABLE ONLY public.inscription_cours DROP CONSTRAINT inscrire;
       public          postgres    false    225    238    3566            �           2606    18176    partie partie_chapitre    FK CONSTRAINT     |   ALTER TABLE ONLY public.partie
    ADD CONSTRAINT partie_chapitre FOREIGN KEY (chapitre_id) REFERENCES public.chapitre(id);
 @   ALTER TABLE ONLY public.partie DROP CONSTRAINT partie_chapitre;
       public          postgres    false    227    217    3542            �           2606    18181    progression progression_partie    FK CONSTRAINT     �   ALTER TABLE ONLY public.progression
    ADD CONSTRAINT progression_partie FOREIGN KEY (partie_id) REFERENCES public.partie(id);
 H   ALTER TABLE ONLY public.progression DROP CONSTRAINT progression_partie;
       public          postgres    false    227    3554    229            �           2606    18186 '   role_utilisateur roles_role_utilisateur    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_utilisateur
    ADD CONSTRAINT roles_role_utilisateur FOREIGN KEY (roles_id) REFERENCES public.role(id);
 Q   ALTER TABLE ONLY public.role_utilisateur DROP CONSTRAINT roles_role_utilisateur;
       public          postgres    false    232    231    3558            �           2606    18191    session_direct session_cours    FK CONSTRAINT     |   ALTER TABLE ONLY public.session_direct
    ADD CONSTRAINT session_cours FOREIGN KEY (cours_id) REFERENCES public.cours(id);
 F   ALTER TABLE ONLY public.session_direct DROP CONSTRAINT session_cours;
       public          postgres    false    3544    234    219                       2606    18196    tentative tentative_examen    FK CONSTRAINT     |   ALTER TABLE ONLY public.tentative
    ADD CONSTRAINT tentative_examen FOREIGN KEY (examen_id) REFERENCES public.examen(id);
 D   ALTER TABLE ONLY public.tentative DROP CONSTRAINT tentative_examen;
       public          postgres    false    3550    223    236            �           2606    18201 #   assignation utilisateur_assignation    FK CONSTRAINT     �   ALTER TABLE ONLY public.assignation
    ADD CONSTRAINT utilisateur_assignation FOREIGN KEY (utilisateur_id) REFERENCES public.utilisateur(id);
 M   ALTER TABLE ONLY public.assignation DROP CONSTRAINT utilisateur_assignation;
       public          postgres    false    238    3566    215            �           2606    18206    creation utilisateur_creation    FK CONSTRAINT     �   ALTER TABLE ONLY public.creation
    ADD CONSTRAINT utilisateur_creation FOREIGN KEY (utilisateur_id) REFERENCES public.utilisateur(id);
 G   ALTER TABLE ONLY public.creation DROP CONSTRAINT utilisateur_creation;
       public          postgres    false    238    3566    220            �           2606    18211 !   evaluation utilisateur_evaluation    FK CONSTRAINT     �   ALTER TABLE ONLY public.evaluation
    ADD CONSTRAINT utilisateur_evaluation FOREIGN KEY (utilisateur_id) REFERENCES public.utilisateur(id);
 K   ALTER TABLE ONLY public.evaluation DROP CONSTRAINT utilisateur_evaluation;
       public          postgres    false    3566    221    238            �           2606    18216 -   role_utilisateur utilisateur_role_utilisateur    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_utilisateur
    ADD CONSTRAINT utilisateur_role_utilisateur FOREIGN KEY (utilisateur_id) REFERENCES public.utilisateur(id);
 W   ALTER TABLE ONLY public.role_utilisateur DROP CONSTRAINT utilisateur_role_utilisateur;
       public          postgres    false    238    3566    232            �   3   x�ɱ  ��a�H��s�t�{C�CA��˂k�m]��0s�"��T\      �   �   x�}�K�0DדS�(��AX��S�Z�ӓ�	���'3#�0c?}>hV�uMM��w`�V��KBe�NI����N�x8�)3�Y5k��H�&\떲Q�Mb�x�¥��	>��!�~f,^�oLC�C�}������ǲ�3���f����=c^c2[
      �   �   x�MбN�0���Sx��:���[%$F� I�B�68ޞ�i�J>�y�O���q��Gܾ4�>bn��M� ,B�&)�1#+d��x*S�ۮ���L�q�OU�Ӹ�ݰ?|��ݺ��9�I�g!�1.��<|m#��s�t�����@`16\_3�b�6�\B�����683�:L,g=������-Fl��G����?�z5J� �R�      �   c   x�E�A1��*lH��K���z�l+q�m1�Ø��L/��3��B	o#�@Kc��;�:�}|G��������nJ�kj���k��6#��^��./�      �     x��RKr�0]���'`"ņr�lZ��_	Ц�������I�7��8��y���Q04�)�gـ��A����~ۀx�Y���{�9�����k��m�Կ����+����F\�lv#�v='�\�&^��lL��n�`%�M^r�50�n2`�;�0 A$5ӽ,�R���p�zd�Z?hQ����+�L���}�<�G�fn��}�/�r&�R�P2�Ξ�����k�9F�HM>�$5��zv�����j�ԧ�?��� �	W�$      �   �  x��UIr�0;���2�d[�?z�KҽnӦ���lI�N�>i�	@ ���v^=^�|W���Y�~]�]=T����Z`�1���f�Xt_��������c��
5����(@u� �#:�.P=�%���������R�wF�ё��9)ԎRA]��30Zb7qKV1�1�c��"���,��ʀ\�#5q8*�Tk#p3�n`"Y�`�8NA�-	�Ȫ`/|ewJ'dkc0�6����&j0���|��nY�)�ȗ]��-�i�r����T��'�����0����G�������nD=��7@��W�(Z�|���rD�n�C؞Fy���Ñ����)n#ׇ7����f�p�Ngٌ�E�ƫ\�G�y)�W�_�	�7-����~���      �   �  x�}TKv�0\���G��(]��.�I[���D�c'mO_�I9r���>��{`�����!;�p�o���_��&�69JV��=����}�-��ˏ��i~}���h���oYʶ�A2�{�~F�4���T�/�Sw��:O@*�GǩN��i���`	�쳄�u�3\���7E�|T�+ΰ�L�#R�Ͱ�8̿�����sW�@�-3I�%s��1��+ �g�M��[�:N*�Hoh�n� ]����qR.���a�#�9	i4�M�6up�,��1�Q�,�+���W\���X�Ɉ��vY��m��\�V�֠��Ԝ��(��=�I�p]��8#��Hl����P���ar��W������k��VFX�7�N���ͻmMbebF%��zk����_A/v�	�n_�D�+rU*L�Xy�+	� �`�_�	�*���7
E8ծ�OD�v
�V7u��f�bf�R{�TC�P���0����� �JNp      �     x���KZ�0���)|��i�G�l��h�hO���W�Į���4#�%����ˇy޵?[�������so�o�3:4ά��'�lW�Ƒd9KEvX0#
ŉW��S~yz�	e���;�E����+��ʝ�'�������-�L빧P�4��K��!�_�
�9X+P�X
$���<}�k���v��*���1��z��3;�|d<z��a�@����c�tzu�{;T0}ƹr�M��a=�)����cx�_�ԩ#,��� =)30���||`�?g��;      �   �   x�M�ˍ1C�R/Z���KΩ �ciF	��	��v�[�#͇Ő\�峵f�)p���<M����,�E+}S��}����i���RNc��*
��Zt͇l
-����!�����F��O%Ǡ+F�����uTk���o(�� BZ*�����y�r�c��g�^Ubn�����$n�*(;ޕ�e��^��S�E�      �   ,   x�3�tL����2�L-)M�L�+�2�L�/�M,I--����� ��
�      �   T   x�%���@B�K1��d{I�u��T`�)T��(�+1���#�[N(�3:d����p�4�׷K�Bx�$������ �~��      �     x�mUIn�0<S��D���-��;H�������9��4T��6JO?���><z���D/��R{&)��.�K�$JC{n��,��������˯��w ���l�ip�Lv ?��Cz6Oړlw XN�y��u��C��S����ຽo���8V�Dv���b���@h_�/)������;_�c�d���ı�P�������뢱�%�P0ٲc܏5 j܆�,�j �]0mZ�Yn�7 ���C0��$YMz�&Nn�hT��b�� � JI.���^dC[�"�� <��$�	c�!;���1��55[_f��C�AZh�)���d��ae.�|C�� g��8�h���I�	?�ܥ.-t%������,��pN{ϵ,CL�Mb�*r���w9a��e!��W����Lɛ�5�E0#?����U[�_���P�v@d��ְ^�� %�F�D�n#�%4�_2w��+��n�WD�;; ��e8����-��I�)d`y�e�K�fFS�%��%ʥ �4�VOPR��0�L�7!�;(lF�ݑ�)S��ŧ��1Ac�B��@���t���4d+���C��GK5l�`�Q��Z��k[��~�2�hHV4�ni���2�\-"0i5f�Q�-�;��Н��z���@�5(�DGq�B���n87��2�j{��E����lV�D�s��g�%�
�z�h9d��= `��֙�-&uz����:�Z�t�$��(�k������&�"Z�(��}�T�`13�WYrؼ�m^�H&�:���8��2�w      �   �  x��UGVC1\+����Y�+�l�@��v\B�'�Ě�fF�T �T����$��V�ϧ�j�5ܽ?>�ˏ���vs9<��|j@'G�2�����by}L/���C��9��\�F)�w-��!@�2�V3� .Ӿ���2��g�	ŀ�P P�L���mȳg��(@9M�҃�i��u���#3��v��~��$�,�N����֑3�i��J��L��FD1�]�@>&'d�W��{�L8@�A	�9ʄ�he���p��f��(V!��B x?��iO�'=�֜��͚a�:�&Ǟ|J}ّ��c�+�TeѥTPvێn��<����((�Ѩ2�!�'�U�H��O����CIק�ĥ�������C]a48���IZ�J�$�̷�Øk�b?퉞�A���=6�M���!cVm�N]���'�k��䛊zUg9I�����	)&'�}'K�,;���<�c̞�.�NД�0Ӧ�RT�dZ,�=��k      �   �  x�uV�r�6<�e]$ �n��+��r�U9�� 	��@pW�	���X ){W��v��3�ӣ�>k;�/��nGi;�1�2��>�󑲺�;��Ң�+Y���O�yϦ��es.lVCR�'�<�m��ԋ4�U$��+��������W�(;i����qP�,x~v�iI*z��Y+�*_�Q�1�wp=벮*VeuF���6Oz��E��`B�sR��Sr������ϣ����#h�����*B�4�:���)���\��,��yu+�������^�p]��٥�y�ʬ�E����d��dn�,C�S������Յ����`˙��*37Ӗ�=�rN��'y��OR�j�mg���(�(E��@�,^��^�ܫ�*��C�߅Q~Gg���:�����+^{��3(.{6�،�e.�'+���<Gߴ� �4l+?���%4F��x}�l�����I�ӯ�j>�?t;Or!�5h����(˪*=��{6��0���K����#zX[>�߷�,�]p�XY�qnt�C�;5�x	zJ��ի��K��lc|3���R_��*��i��ü�@}����9�&���*�����1�3'M�j���6�-���4��6C7&YMgc��/+$l�1�kLf_�&`_�N�yϥ�����r]����#>���L3�K��t�lSP�����\^_��=5��}�24���K�VAW���a�XUeYY�ԲgS�au�K��yI���V�Z��cI��<S�'��r+:��JhȆUg�U�HPσ�f�)�)�͈�_��)��
?ô�Yb6�������pA���{���j��QKO3�IQ����4��+r'���JX�[0������F�1�ÛE-�5�ɠ���������)a���tzY}�h��9�7g R._Q�V�l/k�r�Zt0��Ɔ�����4������W7��tQ>�)��|��'�~�Pٓt7XY�bA��{�37VV$˃����'�Z������6�&w+e�]�SX�U�Q-�n%=��N�A�c�W�Ƨ=���\���� ��>�M:�n�����0`���M!&C�˰ss����?T�xQ61�9C�f�X�c����Ɓ��$|���0�G��F�?�zd�{�Ow��]$�{H�fpw'=���6�3z����l�%,�i�hbzt�18�.ɱ�l}�p(�N�Q�E~���i$��rUp&�`��?$I���"     