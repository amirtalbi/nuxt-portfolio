<template>
  <div class="w-full min-h-screen bg-black text-white">
    <section
      id="hero"
      class="min-h-screen px-6 sm:px-10 lg:px-16 xl:px-20 py-16 flex flex-col justify-center gap-10 container mx-auto"
    >
      <div class="space-y-6 max-w-4xl">
        <p class="text-sm uppercase tracking-[0.4em] text-primary">Amir Talbi · Développeur Full Stack</p>
        <h1 class="text-4xl sm:text-5xl md:text-6xl font-bold leading-tight">
          Je livre des applications full-stack scalables en production
          en moins de 2 semaines — frontend, backend, infra, CI/CD.
        </h1>
        <p class="text-lg sm:text-xl text-gray-300 leading-relaxed">
          Je conçois, développe et maintiens des plateformes qui réduisent les coûts opérationnels, améliorent
          la productivité des équipes métier et renforcent la confiance des utilisateurs grâce à une expérience
          fluide et sécurisée.
        </p>
        <div class="flex flex-wrap gap-3">
          <a
            href="#contact"
            class="px-6 py-3 bg-primary text-black font-semibold rounded-full hover:bg-primary/90 transition"
          >
            Me contacter
          </a>
          <a
            href="https://github.com/amirtalbi"
            target="_blank"
            rel="noopener"
            class="px-6 py-3 border border-gray-600 rounded-full hover:border-primary transition"
          >
            Voir GitHub
          </a>
          <button
            @click="openCvModal"
            class="px-6 py-3 border border-gray-600 rounded-full hover:border-primary transition"
          >
            Télécharger mon CV
          </button>
        </div>
        <div class="grid grid-cols-2 sm:grid-cols-4 gap-4">
          <div class="border border-gray-800 bg-white/5 rounded-2xl p-3">
            <p class="text-3xl font-bold text-primary">10+</p>
            <p class="text-xs text-gray-400 uppercase tracking-[0.2em]">Plateformes livrées</p>
          </div>
          <div class="border border-gray-800 bg-white/5 rounded-2xl p-3">
            <p class="text-3xl font-bold text-primary">3x</p>
            <p class="text-xs text-gray-400 uppercase tracking-[0.2em]">Temps de mise en prod ramené</p>
          </div>
          <div class="border border-gray-800 bg-white/5 rounded-2xl p-3">
            <p class="text-3xl font-bold text-primary">Temps réel</p>
            <p class="text-xs text-gray-400 uppercase tracking-[0.2em]">Notifications & WebSockets</p>
          </div>
          <div class="border border-gray-800 bg-white/5 rounded-2xl p-3">
            <p class="text-3xl font-bold text-primary">Full stack</p>
            <p class="text-xs text-gray-400 uppercase tracking-[0.2em]">Apps, APIs, Infra</p>
          </div>
        </div>
      </div>
    </section>

    <section
      id="about"
      class="px-6 sm:px-10 lg:px-16 xl:px-20 py-16 border-t border-gray-800 bg-gradient-to-b from-black/80 to-black/60"
    >
      <div class="max-w-5xl mx-auto grid gap-10 lg:grid-cols-[1fr_1.2fr] items-center">
        <div>
          <p class="text-xs uppercase tracking-[0.4em] text-primary">À propos</p>
          <h2 class="text-3xl sm:text-4xl font-semibold text-white mt-4">Créateur de produits numériques fiables & adaptables</h2>
          <p class="mt-4 text-gray-300 leading-relaxed">
            Je travaille avec des équipes produit et des entrepreneurs pour transformer un besoin métier en
            architecture robuste, API performante, interface fluide et pipeline déployable. Je privilégie la
            communication claire dans les spec, la documentation automatique et les tests end-to-end.
          </p>
          <p class="mt-4 text-sm text-gray-400">
            Recherche : CDI full-stack, mission freelance ou collaboration concrète avec les CTOs qui veulent
            déléguer la pile complète (frontend, backend, sécurité, observabilité).
          </p>
        </div>
        <div class="grid gap-4">
          <div class="p-6 border border-gray-800 bg-white/5 rounded-2xl shadow-lg">
            <p class="text-sm uppercase tracking-[0.3em] text-gray-400">Focus actuel</p>
            <p class="text-lg sm:text-xl text-white font-semibold mt-2">Produits SaaS en compliance légale (VTC, mobilité, fintech).</p>
          </div>
          <div class="p-6 border border-gray-800 bg-white/5 rounded-2xl shadow-lg">
            <p class="text-sm uppercase tracking-[0.3em] text-gray-400">Expertise</p>
            <p class="text-lg sm:text-xl text-white font-semibold mt-2">Frontend moderne, API modulaires et pipelines Docker + Traefik.</p>
          </div>
        </div>
      </div>
    </section>

    <section
      id="projects"
      class="px-6 sm:px-10 lg:px-16 xl:px-20 py-16"
    >
      <div class="max-w-5xl mx-auto">
        <p class="text-xs uppercase tracking-[0.4em] text-primary">Projets</p>
        <h2 class="text-3xl sm:text-4xl font-semibold text-white mt-4">3 projets qui démontrent mon impact</h2>
        <p class="text-gray-400 mt-2">Front, back-office, API, DevOps — chaque projet est accompagné d’un rôle clair, d’un enjeu et d’un résultat mesurable.</p>

        <div class="grid gap-8 mt-10">
          <UCard
            v-for="project in featuredProjects"
            :key="project.name"
            class="bg-gray-900/50 border border-gray-800 rounded-3xl shadow-2xl"
          >
            <div class="p-6 lg:p-10 space-y-5">
              <div class="flex flex-wrap items-center gap-3">
                <h3 class="text-2xl font-bold text-white">{{ project.name }}</h3>
                <span
                  :class="project.status === 'Live' ? 'bg-green-500/10 text-green-400 border-green-500/20' : 'bg-yellow-500/10 text-yellow-400 border-yellow-500/20'"
                  class="px-3 py-1 text-xs font-medium rounded-full border"
                >
                  {{ project.status }}
                </span>
              </div>
              <p class="text-lg text-primary font-medium">{{ project.title }}</p>
              <p class="text-gray-300 leading-relaxed">{{ project.description }}</p>
              <div class="grid gap-4 md:grid-cols-3">
                <div>
                  <p class="text-xs uppercase tracking-[0.3em] text-gray-400">Enjeu</p>
                  <p class="text-white font-semibold text-sm">{{ project.challenge }}</p>
                </div>
                <div>
                  <p class="text-xs uppercase tracking-[0.3em] text-gray-400">Rôle</p>
                  <p class="text-white font-semibold text-sm">{{ project.role }}</p>
                </div>
                <div v-if="project.impact != null">
                  <p class="text-xs uppercase tracking-[0.3em] text-gray-400">Impact</p>
                  <p class="text-white font-semibold text-sm">{{ project.impact }}</p>
                </div>
              </div>
              <div class="flex flex-wrap gap-2">
                <span
                  v-for="tech in project.technologies"
                  :key="tech"
                  class="px-3 py-1 rounded-full border border-gray-800 text-xs text-gray-300 bg-white/5"
                >
                  {{ tech }}
                </span>
              </div>
              <div class="flex flex-wrap gap-3">
                <a
                  v-if="project.link"
                  :href="project.link"
                  target="_blank"
                  rel="noopener"
                  class="px-5 py-2 rounded-full bg-primary text-black font-semibold hover:bg-primary/90 transition"
                >
                  Voir le projet
                </a>
                <a
                  v-if="project.repo"
                  :href="project.repo"
                  target="_blank"
                  rel="noopener"
                  class="px-5 py-2 rounded-full border border-gray-700 text-gray-200 hover:border-primary transition"
                >
                  Voir le code
                </a>
                <p v-if="project.metrics" class="text-xs uppercase tracking-[0.3em] text-gray-500">{{ project.metrics }}</p>
              </div>
            </div>
          </UCard>
        </div>
      </div>
    </section>

    <section
      class="px-6 sm:px-10 lg:px-16 xl:px-20 pb-16"
    >
      <div class="max-w-5xl mx-auto">
        <div class="flex items-center justify-between mb-6">
          <div>
            <p class="text-xs uppercase tracking-[0.4em] text-primary">Autres réalisations</p>
            <h2 class="text-3xl sm:text-4xl font-semibold text-white mt-2">Archive & projets annexes</h2>
            <p class="text-gray-400 mt-1">Projets qui complètent la palette technique sans surcharger la homepage.</p>
          </div>
          <a
            href="#contact"
            class="px-5 py-2 rounded-full border border-gray-700 text-gray-200 hover:border-primary transition"
          >
            Discuter d’un projet
          </a>
        </div>
        <div class="grid gap-4 md:grid-cols-2">
          <div
            v-for="project in otherProjects"
            :key="project.name"
            class="border border-gray-800 rounded-2xl p-5 bg-gray-900/50"
          >
            <div class="flex items-center justify-between">
              <h3 class="text-xl font-semibold text-white">{{ project.name }}</h3>
              <span class="text-xs uppercase tracking-[0.3em] text-gray-400">{{ project.status }}</span>
            </div>
            <p class="mt-2 text-gray-300 text-sm leading-relaxed">{{ project.summary }}</p>
            <p class="mt-3 text-xs text-gray-400 uppercase tracking-[0.3em]">Stack principale</p>
            <div class="flex flex-wrap gap-2 mt-1">
              <span
                v-for="tech in project.technologies"
                :key="tech"
                class="px-3 py-1 rounded-full border border-gray-800 text-xs text-gray-300"
              >
                {{ tech }}
              </span>
            </div>
            <div class="flex flex-wrap gap-3 mt-4">
              <a
                v-if="project.link"
                :href="project.link"
                target="_blank"
                rel="noopener"
                class="text-sm font-semibold text-primary hover:text-primary/70"
              >
                Lien live
              </a>
              <a
                v-if="project.repo"
                :href="project.repo"
                target="_blank"
                rel="noopener"
                class="text-sm font-semibold text-primary hover:text-primary/70"
              >
                Voir le code
              </a>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section
      id="skills"
      class="px-6 sm:px-10 lg:px-16 xl:px-20 py-16 border-t border-gray-800"
    >
      <div class="max-w-5xl mx-auto">
        <div class="flex flex-wrap items-center justify-between gap-4 mb-10">
          <div>
            <p class="text-xs uppercase tracking-[0.4em] text-primary">Compétences</p>
            <h2 class="text-3xl sm:text-4xl font-semibold text-white mt-2">Stack techniques maîtrisées</h2>
            <p class="text-gray-400 mt-1">Frontend, backend, DevOps et bases de données : tout ce qu’il faut pour une stack complète.</p>
          </div>
          <a
            href="mailto:amirotalbi94@gmail.com"
            class="px-5 py-2 rounded-full border border-gray-700 text-gray-200 hover:border-primary transition"
          >
            Discutons tech
          </a>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <UCard
            v-for="(skillCategory, index) in skills"
            :key="index"
            class="bg-gray-900/50 border border-gray-800 rounded-2xl shadow-xl"
          >
            <div class="p-6 space-y-4">
              <div class="flex items-center gap-3">
                <div
                  :class="`w-12 h-12 rounded-xl flex items-center justify-center shadow-lg bg-gradient-to-br ${skillCategory.color}`"
                >
                  <Icon :name="skillCategory.icon" class="text-white text-xl" />
                </div>
                <h3 class="text-xl font-semibold text-white">{{ skillCategory.category }}</h3>
              </div>
              <div class="flex flex-wrap gap-2">
                <span
                  v-for="skill in skillCategory.skills"
                  :key="skill"
                  class="px-3 py-1.5 rounded-full border border-gray-800 text-sm text-gray-300"
                >
                  {{ skill }}
                </span>
              </div>
            </div>
          </UCard>
        </div>
      </div>
    </section>

    <section
      id="contact"
      class="px-6 sm:px-10 lg:px-16 xl:px-20 py-16 bg-gradient-to-t from-black/80 to-transparent"
    >
      <div class="max-w-5xl mx-auto border border-gray-800 rounded-3xl p-10 bg-white/5 shadow-2xl">
        <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-6">
          <div>
            <p class="text-xs uppercase tracking-[0.4em] text-primary">Contact</p>
            <h2 class="text-3xl sm:text-4xl font-semibold text-white mt-3">Prêt pour une collaboration concrète ?</h2>
            <p class="text-gray-300 mt-2">Je réponds rapidement aux missions full stack, au consulting infrastructure et aux renforts DevOps.</p>
          </div>
          <div class="space-y-2">
            <a
              href="mailto:amirotalbi94@gmail.com"
              class="inline-flex items-center gap-2 px-6 py-3 rounded-full bg-primary text-black font-semibold"
            >
              <Icon name="fa:envelope" />
              Envoyer un message
            </a>
            <div class="flex gap-3">
              <a
                href="https://www.linkedin.com/in/amirtalbi"
                target="_blank"
                rel="noopener"
                class="px-4 py-2 border border-gray-700 rounded-full hover:border-primary transition"
              >
                LinkedIn
              </a>
              <a
                href="https://github.com/amirtalbi"
                target="_blank"
                rel="noopener"
                class="px-4 py-2 border border-gray-700 rounded-full hover:border-primary transition"
              >
                GitHub
              </a>
            </div>
          </div>
        </div>
        <div class="mt-8 text-sm text-gray-400 grid gap-2 sm:grid-cols-2">
          <p>Disponible pour CDI, freelance ou missions à distance. Localisé à Paris et disponible pour déplacements courts.</p>
          <p>CV & stack à jour : <button @click="openCvModal" class="text-primary underline">ouvrir le CV</button></p>
        </div>
      </div>
    </section>

    <footer
      class="py-8 px-6 sm:px-10 border-t border-gray-800 text-gray-400"
    >
      <div class="max-w-5xl mx-auto flex flex-col md:flex-row items-center justify-between gap-4">
        <p>© {{ new Date().getFullYear() }} Amir Talbi — Full Stack Developer</p>
        <div class="flex gap-4">
          <NuxtLink to="https://www.linkedin.com/in/amirtalbi" target="_blank" external>
            LinkedIn
          </NuxtLink>
          <NuxtLink to="https://github.com/amirtalbi" target="_blank" external>
            GitHub
          </NuxtLink>
          <NuxtLink to="/amir-talbi-cv.pdf" target="_blank">
            CV</NuxtLink>
        </div>
      </div>
    </footer>

    <Teleport to="body" v-if="showCvModal">
      <div
        class="fixed inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-sm p-4"
        @click="closeCvModal"
      >
        <div
          class="bg-gray-900 rounded-2xl overflow-hidden max-w-6xl w-full max-h-[95vh] md:max-h-[90vh] overflow-y-auto"
          @click.stop
        >
          <div class="flex items-center justify-between p-4 md:p-6 border-b border-gray-700">
            <div class="flex items-center gap-3">
              <div class="w-8 h-8 md:w-10 md:h-10 bg-gradient-to-r from-primary to-orange-500 rounded-lg flex items-center justify-center">
                <Icon name="fa:file-pdf-o" class="text-white text-sm md:text-lg" />
              </div>
              <div>
                <h3 class="text-lg md:text-xl font-bold text-white">Curriculum Vitae</h3>
                <p class="text-xs md:text-sm text-gray-400">Amir Talbi - Développeur Full Stack</p>
              </div>
            </div>
            <button
              @click="closeCvModal"
              class="w-8 h-8 rounded-full bg-gray-800 hover:bg-gray-700 flex items-center justify-center"
            >
              <Icon name="fa:times" class="text-gray-400 hover:text-white" />
            </button>
          </div>
          <div class="p-4 md:p-6">
            <div v-if="isMobile" class="bg-gray-800/50 rounded-xl p-4 mb-4 md:mb-6 flex flex-col items-center justify-center">
              <Icon name="fa:file-pdf-o" class="text-4xl text-red-500 mb-2" />
              <p class="text-base font-medium mb-2 text-center">Aperçu du CV non supporté sur mobile.</p>
              <a href="/amir-talbi-cv.pdf" target="_blank" class="px-4 py-2 bg-primary text-black rounded-lg font-medium">Ouvrir dans un nouvel onglet</a>
              <a href="/amir-talbi-cv.pdf" download class="px-4 py-2 bg-blue-600 text-white rounded-lg font-medium">Télécharger</a>
            </div>
            <div v-else class="bg-gray-800/50 rounded-xl p-2 md:p-4 mb-4 md:mb-6">
              <div class="aspect-[210/297] bg-white rounded-lg overflow-hidden">
                <iframe
                  src="/amir-talbi-cv.pdf#toolbar=0&navpanes=0&scrollbar=0"
                  class="w-full h-full rounded-lg"
                  title="Aperçu du CV"
                  @error="handleIframeError"
                ></iframe>
                <div v-if="iframeError" class="absolute inset-0 flex items-center justify-center bg-white rounded-lg">
                  <div class="text-center text-gray-600 p-4">
                    <Icon name="fa:file-pdf-o" class="text-4xl md:text-6xl mb-2 text-red-500" />
                    <p class="text-base md:text-lg font-medium">Aperçu du CV</p>
                    <p class="text-xs md:text-sm">amir-talbi-cv.pdf</p>
                  </div>
                </div>
              </div>
            </div>
            <div class="flex flex-col sm:flex-row gap-3 md:gap-4 justify-center">
              <button
                @click="closeCvModal"
                class="px-4 md:px-6 py-2 md:py-3 bg-gray-700 hover:bg-gray-600 text-white rounded-lg font-medium"
              >
                Fermer
              </button>
              <a href="/amir-talbi-cv.pdf" download class="px-4 md:px-6 py-2 md:py-3 bg-primary text-black rounded-lg font-medium">
                <Icon name="fa:download" /> Télécharger
              </a>
              <a href="/amir-talbi-cv.pdf" target="_blank" rel="noopener" class="px-4 md:px-6 py-2 md:py-3 bg-blue-600 text-white rounded-lg font-medium">
                <Icon name="fa:external-link" /> Ouvrir
              </a>
            </div>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from "vue";

const showCvModal = ref(false);
const iframeError = ref(false);
const isMobile = ref(false);

onMounted(() => {
  isMobile.value = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(
    navigator.userAgent
  );
  if (process.client) {
    document.addEventListener("keydown", handleKeydown);
  }
});

onUnmounted(() => {
  if (process.client) {
    document.removeEventListener("keydown", handleKeydown);
    document.body.style.overflow = "auto";
  }
});

const openCvModal = () => {
  showCvModal.value = true;
  iframeError.value = false;
  if (process.client) {
    document.body.style.overflow = "hidden";
  }
};

const closeCvModal = () => {
  showCvModal.value = false;
  if (process.client) {
    document.body.style.overflow = "auto";
  }
};

const handleIframeError = () => {
  iframeError.value = true;
};

const handleKeydown = (event) => {
  if (event.key === "Escape" && showCvModal.value) {
    closeCvModal();
  }
};

const featuredProjects = ref([
  {
    name: "TripLegal",
    title: "Plateforme juridique pour chauffeurs VTC",
    description:
      "J’ai conçu TripLegal comme une suite verticale où les chauffeurs rédigent des bons de commande, gèrent les paiements et restent conformes au cadre légal en quelques clics.",
    status: "Live",
    challenge: "Structurer un stack complet (frontend, API, infra) pour digitaliser la conformité en quelques semaines.",
    role: "Lead dev full stack · CI/CD, API NestJS, Nuxt + Traefik + Postgres.",
  impact: "Permet aux chauffeurs VTC autour de moi de gérer leurs courses hors plateformes classiques, de centraliser commandes/paiements et de rester conformes sans attendre un support externe.",
    technologies: ["Nuxt.js", "NestJS", "PostgreSQL", "Traefik", "Docker"],
    link: "https://triplegal.fr",
    repo: "https://github.com/amirtalbi/triplegal",
    metrics: null,
  },
  {
    name: "GoVTC API",
    title: "API temps réel pour plateforme VTC",
    description:
      "J’ai développé une API modulaire (auth, paiement, géolocalisation, WebSockets) qui alimente les apps clients, chauffeurs et dispatchers.",
    status: "Maintenance",
    challenge: "Permettre l’échange multi-acteurs et la communication en temps réel avec un seul service NestJS.",
    role: "Backend Lead · architecture modulaire, WebSockets, observabilité Prometheus + Grafana.",
  impact: null,
    technologies: ["NestJS", "Socket.io", "MongoDB", "Docker", "Redis"],
    link: "https://go-vtc.amirtalbi.me/",
    repo: "https://github.com/amirtalbi/go-vtc-api",
    metrics: null,
  },
  {
    name: "Rent a Park",
    title: "Marketplace de places de parking",
    description:
      "Réalisation d’une marketplace Web/Mobile (Nuxt/Nest) avec réservation, géolocalisation, paiement Stripe et suivi de disponibilité temps réel.",
    status: "MVP",
    challenge: "Accélérer la livraison d’une MVP fonctionnelle en moins de 2 semaines tout en sécurisant le paiement et les disponibilités.",
    role: "Lead full stack · Nuxt 3, NestJS, Stripe, tests E2E, déploiement Traefik + Mongo.",
  impact: null,
    technologies: ["Nuxt 3", "NestJS", "MongoDB", "Stripe", "Traefik"],
    link: null,
    repo: null,
    metrics: null,
  },
]);

const otherProjects = ref([
  {
    name: "Webinnov Paris",
    status: "Live",
    summary: "Site vitrine statique riche en contenus dynamiques pour l’agence Webinnov — décliné sur Nuxt, Tailwind et newsletter API.",
    technologies: ["Nuxt.js", "Tailwind CSS", "Markdown", "Netlify"],
    link: "https://webinnov-paris.fr/",
  },
  {
    name: "Morpion",
    status: "Archive",
    summary: "Jeu WebSocket en duo (Vue + Express) pour comprendre la synchronisation temps réel et les sessions partagées.",
    technologies: ["Vue.js", "Socket.io", "Docker"],
    repo: "https://github.com/amirtalbi/morpion-web-socket",
  },
  {
    name: "GoMemories",
    status: "Prototype",
    summary: "Plateforme de souvenirs avec upload, minio + API Express et authentification JWT.",
    technologies: ["Vue.js", "Minio", "Node.js"],
  },
]);

const skills = ref([
  {
    category: "Frontend",
    icon: "fa:code",
    color: "from-blue-400 to-blue-600",
    skills: ["Vue.js", "Nuxt.js", "JavaScript", "TypeScript", "HTML", "CSS", "Tailwind"],
  },
  {
    category: "Backend",
    icon: "fa:server",
    color: "from-green-400 to-green-600",
    skills: ["Node.js", "NestJS", "Express", "API REST", "GraphQL", "Socket.io"],
  },
  {
    category: "DevOps",
    icon: "fa:cogs",
    color: "from-purple-400 to-purple-600",
    skills: ["Docker", "Traefik", "GitHub Actions", "Linux", "Nginx", "Monitoring"],
  },
  {
    category: "Bases de données",
    icon: "fa:database",
    color: "from-orange-400 to-orange-600",
    skills: ["MongoDB", "PostgreSQL", "Redis", "Prisma", "Mongoose"],
  },
  {
    category: "Outils & Tech",
    icon: "fa:wrench",
    color: "from-pink-400 to-pink-600",
    skills: ["VS Code", "Figma", "Postman", "Rclone", "Socket.io"],
  },
]);
</script>
