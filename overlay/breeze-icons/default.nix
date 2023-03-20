{channels, ...}:

final: prev: {
    breeze-icons = prev.breeze-icons.overrideAttrs (o: {
        patches = (o.patches or []) ++ [
            ./avatar.patch
            ./avatar-dark.patch
        ];
    })
}