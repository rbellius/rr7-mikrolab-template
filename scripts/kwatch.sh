#  gum spin --spinner dot --title "Waiting for CRD arogfiles.kro.run to be created" -- time kubectl wait --for=create crds argofiles.kro.run --timeout=-1s; 
#  gum style --foreground 2 --bold "CRD argofiles.kro.run created successfully";


# all passed params
readyIcon=$(echo -e "\e[0;32m\u2714\e[0m")



function kwaiting {
    local kind=$1
    local desiredCount=$(kubectl get --kubeconfig mikrolab/kubeconfig.yaml $kind -A -o=jsonpath='{.items[*].kind}' | wc -w)

    gum spin --spinner moon --title "Waiting for $kind to be ready" -- kubectl wait --for=condition=Established --timeout=-1s crds $kind;

    local results=$(kubectl get --kubeconfig mikrolab/kubeconfig.yaml $kind -A -o=jsonpath='{.items[*].kind}' | wc -w)

    if [[ "$results" -ge "$desiredCount" ]]; then
        gum style --foreground 2 --bold "${readyIcon} $kind is ready with ${results} of desired ${desiredCount}";
    else
        gum style --foreground 1 --bold "Failed to get $kind ready. Found ${results} of desired ${desiredCount}";
    fi
}

function kwait {
    kind=$1

    gum spin --spinner moon -- kubectl wait --for=condition=Established --timeout=-1s crds $kind ;
    gum style --foreground 2 --bold "${readyIcon} $kind is established";
}

# for kind in "$@"; do
#     kwait $kind #&
# done

echo "Waiting for CRDs to be established..."
gum spin --spinner moon -- kubectl wait --for=condition=Established --timeout=-1s crds applications.argoproj.io
gum style --foreground 2 --bold "${readyIcon} Applications is established";


gum spin --spinner moon -- kubectl wait --for=condition=Established --timeout=-1s crds applicationssets.argoproj.io
gum style --foreground 2 --bold "${readyIcon} ApplicationSets is established";


gum spin --spinner moon -- kubectl wait --for=condition=Established --timeout=-1s crds resourcegraphdefinitions.argoproj.io
gum style --foreground 2 --bold "${readyIcon} ResourceGraphDefinition is established";

gum spin --spinner moon -- kubectl wait --for=condition=Established --timeout=-1s crds argofiles.kro.run
gum style --foreground 2 --bold "${readyIcon} ArgoFiles is established";

gum spin --spinner moon -- kubectl wait --for=condition=Established --timeout=-1s crds mikrolabfiles.kro.run
gum style --foreground 2 --bold "${readyIcon} MikrolabFiles is established";